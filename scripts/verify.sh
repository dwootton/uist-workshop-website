#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

required_files=(
  "index.html"
  "styles.css"
  "uist-26/index.html"
  "uist-26/styles.css"
  "CNAME"
  ".github/workflows/pages.yml"
  "scripts/verify.sh"
  ".nojekyll"
  "README.md"
  "assets/organizers/helena-vasconcelos.jpg"
  "assets/organizers/dora-zhao.png"
  "assets/organizers/michelle-lam.jpg"
  "assets/organizers/dylan-wootton.jpg"
  "assets/organizers/omar-shaikh.jpeg"
  "assets/organizers/andy-matuschak.webp"
  "assets/organizers/mitchell-gordon.png"
  "assets/organizers/michael-bernstein.jpg"
  "assets/fonts/inter-latin-400-700.woff2"
)

for file in "${required_files[@]}"; do
  [[ -f "$file" ]] || {
    echo "Missing required file: $file" >&2
    exit 1
  }
done

landing_copy=(
  "The Personalized Computer for the 21st Century"
  "We are exploring what"
  "UIST 2026 workshop"
)

for phrase in "${landing_copy[@]}"; do
  rg -Fq "$phrase" index.html || {
    echo "Missing landing-page copy: $phrase" >&2
    exit 1
  }
done

required_copy=(
  "The Personalized Computer for the 21st Century"
  "Personal computers have rarely been truly personal."
  "What should computers do when they know us deeply and can act on what they know?"
  "Apply to participate ↗"
  "No virtual attendance will be offered."
  "Monday, November 2, 2026"
)

for phrase in "${required_copy[@]}"; do
  rg -Fq "$phrase" uist-26/index.html || {
    echo "Missing required copy: $phrase" >&2
    exit 1
  }
done

placeholder_tokens=(
  "REPLACE_GOOGLE_FORM_URL"
  "REPLACE_APPLICATION_DEADLINE"
  "REPLACE_DECISION_DATE"
  "REPLACE_VENUE_CITY"
)

for token in "${placeholder_tokens[@]}"; do
  rg -Fq "$token" uist-26/index.html README.md || {
    echo "Missing placeholder token: $token" >&2
    exit 1
  }
done

rg -Fq '<link rel="stylesheet" href="styles.css">' index.html || {
  echo "Stylesheet link must remain relative." >&2
  exit 1
}

rg -Fq 'href="uist-26/"' index.html || {
  echo "Landing page must link to the uist-26 route." >&2
  exit 1
}

for stylesheet in styles.css uist-26/styles.css; do
  rg -Fq 'font-family: "Inter";' "$stylesheet" || {
    echo "Inter must be the locally bundled site font in $stylesheet." >&2
    exit 1
  }

  if rg -ni '(^|[^-])serif|georgia|palatino|times new roman' "$stylesheet" >/dev/null; then
    echo "Serif font references are not allowed in $stylesheet." >&2
    exit 1
  fi
done

rg -Fq '<link rel="stylesheet" href="styles.css">' uist-26/index.html || {
  echo "Workshop stylesheet link must remain relative." >&2
  exit 1
}

rg -Fq 'src="../assets/organizers/' uist-26/index.html || {
  echo "Workshop organizer paths must resolve from uist-26." >&2
  exit 1
}

rg -Fq 'url("../assets/fonts/inter-latin-400-700.woff2")' uist-26/styles.css || {
  echo "Workshop font path must resolve from uist-26." >&2
  exit 1
}

if rg -n '(src|poster)=["'\'']https?://' index.html uist-26/index.html >/dev/null; then
  echo "External asset URLs are not allowed in HTML." >&2
  exit 1
fi

if rg -n 'url\(["'\'']?https?://' styles.css uist-26/styles.css >/dev/null; then
  echo "External asset URLs are not allowed in CSS." >&2
  exit 1
fi

landmark_checks=(
  'href="#main-content"'
  '<main id="main-content">'
  '<header class="site-header shell">'
  '<section class="section shell" id="program"'
  '<section class="section shell" id="participation"'
  '<section class="section shell" id="organizers"'
  '<footer class="site-footer shell">'
)

for fragment in "${landmark_checks[@]}"; do
  rg -Fq "$fragment" uist-26/index.html || {
    echo "Missing landmark or structure fragment: $fragment" >&2
    exit 1
  }
done

organizer_links=(
  "https://helenavasc.com/"
  "https://dorazhao99.github.io/"
  "https://michelle123lam.github.io/"
  "https://www.dylanwootton.com/"
  "https://oshaikh.com/"
  "https://andymatuschak.org/"
  "https://mitchellg.github.io/"
  "https://hci.stanford.edu/msb/"
)

for url in "${organizer_links[@]}"; do
  rg -Fq "$url" uist-26/index.html || {
    echo "Missing organizer link: $url" >&2
    exit 1
  }
done

for stylesheet in styles.css uist-26/styles.css; do
  open_braces="$(tr -cd '{' < "$stylesheet" | wc -c | tr -d ' ')"
  close_braces="$(tr -cd '}' < "$stylesheet" | wc -c | tr -d ' ')"
  [[ "$open_braces" == "$close_braces" ]] || {
    echo "$stylesheet has unbalanced braces." >&2
    exit 1
  }
done

[[ "$(tr -d '\r\n' < CNAME)" == "personalized.computer" ]] || {
  echo "CNAME must contain personalized.computer." >&2
  exit 1
}

rg -Fq 'cp -R uist-26 _site/' .github/workflows/pages.yml || {
  echo "Workflow must publish the uist-26 route." >&2
  exit 1
}

workflow_checks=(
  'actions/checkout@11d5960a326750d5838078e36cf38b85af677262 # v4'
  'actions/configure-pages@983d7736d9b0ae728b81ab479565c72886d7745b # v5'
  'actions/upload-pages-artifact@7b1f4a764d45c48632c6b24a0339c27f5614fb0b # v4'
  'actions/deploy-pages@d6db90164ac5ed86f2b6aed7e0febac5b3c0c03e # v4'
)

for action_ref in "${workflow_checks[@]}"; do
  rg -Fq "$action_ref" .github/workflows/pages.yml || {
    echo "Workflow missing official action reference: $action_ref" >&2
    exit 1
  }
done

bash -n scripts/verify.sh

python3 - <<'PY'
from html.parser import HTMLParser
import http.server
import io
import os

root = os.getcwd()


class StructureParser(HTMLParser):
    void_elements = {
        "area", "base", "br", "col", "embed", "hr", "img", "input", "link",
        "meta", "param", "source", "track", "wbr",
    }

    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.stack = []
        self.ids = set()

    def handle_starttag(self, tag, attrs):
        for name, value in attrs:
            if name == "id":
                if value in self.ids:
                    raise ValueError(f"Duplicate HTML id: {value}")
                self.ids.add(value)
        if tag not in self.void_elements:
            self.stack.append(tag)

    def handle_endtag(self, tag):
        if not self.stack or self.stack[-1] != tag:
            expected = self.stack[-1] if self.stack else "no open element"
            raise ValueError(f"Unexpected closing tag </{tag}>; expected </{expected}>")
        self.stack.pop()


for html_path in ("index.html", "uist-26/index.html"):
    parser = StructureParser()
    with open(html_path, encoding="utf-8") as html_file:
        parser.feed(html_file.read())
    parser.close()
    if parser.stack:
        raise SystemExit(f"Unclosed HTML elements in {html_path}: {', '.join(parser.stack)}")


class Probe(http.server.SimpleHTTPRequestHandler):
    def __init__(self, path, directory):
        self.path = f"/{path}"
        self.directory = directory
        self.command = "GET"
        self.request_version = "HTTP/1.1"
        self.requestline = f"GET /{path} HTTP/1.1"
        self.headers = {}
        self.rfile = io.BytesIO()
        self.wfile = io.BytesIO()
        self.status_code = None
        self.sent_headers = {}

    def send_response(self, code, message=None):
        self.status_code = code

    def send_header(self, keyword, value):
        self.sent_headers[keyword] = value

    def end_headers(self):
        return None

    def log_message(self, format, *args):
        return None


for path in (
    "index.html",
    "styles.css",
    "uist-26/index.html",
    "uist-26/styles.css",
    "assets/organizers/dora-zhao.png",
):
    probe = Probe(path, root)
    served = probe.send_head()
    if probe.status_code != 200 or served is None:
        raise SystemExit(f"Local handler did not return {path} successfully.")
    served.close()
PY

echo "Verification passed."
