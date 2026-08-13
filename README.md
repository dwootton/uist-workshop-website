# UIST 2026 workshop site

Minimal GitHub Pages site for **The Personalized Computer for the 21st Century**, an in-person UIST 2026 workshop.

The design combines the content economy of [dylanwootton.com](https://www.dylanwootton.com/) with the dense, monochrome workshop presentation of [aiagentbehavior.com](https://www.aiagentbehavior.com/).

## Local preview

Run the repository verification script:

```bash
./scripts/verify.sh
```

To preview manually after verification:

```bash
python3 -m http.server 8000
```

Then open `http://127.0.0.1:8000/index.html`.

## Deployment

GitHub Actions deploys the repository root to GitHub Pages without a build step. The workflow stages only:

- `index.html`
- `styles.css`
- `assets/`
- `.nojekyll`

That keeps `.omx`, git metadata, and other repository files out of the published artifact.

## Organizer portraits

Portraits were downloaded from organizer-controlled or official institutional pages and are linked back to the organizers' homepages:

- Helena Vasconcelos — [Harvard CHARM](https://charm.seas.harvard.edu/?page_id=37)
- Dora Zhao — [personal site](https://dorazhao99.github.io/)
- Michelle S. Lam — [personal site](https://michelle123lam.github.io/)
- Dylan Wootton — [University of Utah VDL](https://vdl.sci.utah.edu/team/wootton/)
- Omar Shaikh — [personal site](https://oshaikh.com/)
- Andy Matuschak — [Foresight Institute](https://foresight.org/people/andy-matuschak/)
- Mitchell Gordon — [personal site](https://mitchellg.github.io/)
- Michael S. Bernstein — [Stanford HCI](https://hci.stanford.edu/msb/)

## Launch checklist

Replace these source placeholders before announcing the site. Until then, the page shows bracketed placeholder copy:

- `REPLACE_GOOGLE_FORM_URL`
- `REPLACE_APPLICATION_DEADLINE`
- `REPLACE_DECISION_DATE`
- `REPLACE_WORKSHOP_DATE`
- `REPLACE_VENUE_CITY`
