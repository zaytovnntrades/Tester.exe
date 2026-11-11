"""Scout: pull recent headlines from public RSS/Atom feeds into a raw digest.

Usage:
    python tools/scout/rss_spider.py            # live run
    python tools/scout/rss_spider.py --dev      # development mode (cached responses)

Writes research/raw/feeds-YYYY-MM-DD.json. Claude then curates up to 10 items
into research/YYYY-MM-DD.md (headline · why it matters · URL · date · pillar #).

Written against Scrapling 0.5.x (scrapling.spiders.XMLFeedSpider, verified in the
installed package source). Recheck the API if you upgrade Scrapling.
"""

import argparse
import datetime as dt
from pathlib import Path

from scrapling.spiders import XMLFeedSpider

ROOT = Path(__file__).resolve().parents[2]
FEEDS_FILE = Path(__file__).with_name("feeds.txt")
PER_FEED = 15  # newest N items per feed


def load_feeds() -> list[str]:
    lines = FEEDS_FILE.read_text(encoding="utf-8").splitlines()
    return [ln.strip() for ln in lines if ln.strip() and not ln.lstrip().startswith("#")]


class FinanceFeedSpider(XMLFeedSpider):
    name = "finance_feeds"
    itertag = "item"  # RSS 2.0; Atom entries are handled below
    robots_txt_obey = True  # CLAUDE.md §5.1: always obey robots.txt
    download_delay = 1.0
    concurrent_requests = 2

    def __init__(self, *args, **kwargs):
        self.start_urls = load_feeds()
        super().__init__(*args, **kwargs)
        self._seen: dict[str, int] = {}

    def _iter_nodes(self, root):
        # Yield RSS <item> and Atom <entry> nodes, so one spider covers both formats.
        for tag in ("item", "entry"):
            self.itertag = tag
            yield from super()._iter_nodes(root)
        self.itertag = "item"

    async def parse_node(self, response, node):
        source = str(response.url)
        count = self._seen.get(source, 0)
        if count >= PER_FEED:
            return
        self._seen[source] = count + 1

        link = (node.findtext("link") or "").strip()
        if not link:  # Atom: <link href="..."/>
            link_el = node.find("link")
            link = link_el.get("href", "") if link_el is not None else ""

        yield {
            "feed": source,
            "title": (node.findtext("title") or "").strip(),
            "link": link.strip(),
            "date": (
                node.findtext("pubDate")
                or node.findtext("published")
                or node.findtext("updated")
                or node.findtext("date")
                or ""
            ).strip(),
            "summary": (node.findtext("description") or node.findtext("summary") or "").strip()[:400],
        }


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--dev", action="store_true", help="development mode: cache responses on disk")
    args = ap.parse_args()

    if args.dev:
        FinanceFeedSpider.development_mode = True
        FinanceFeedSpider.development_cache_dir = str(ROOT / "tools/scout/.cache")

    result = FinanceFeedSpider().start()
    out = ROOT / "research/raw" / f"feeds-{dt.date.today().isoformat()}.json"
    out.parent.mkdir(parents=True, exist_ok=True)
    result.items.to_json(out, indent=True)
    print(f"{len(result.items)} items -> {out.relative_to(ROOT)}")
    print(f"robots.txt blocks: {result.stats.robots_disallowed_count} · failed requests: {result.stats.failed_requests_count}")


if __name__ == "__main__":
    main()
