# UIST 2026 workshop site

Minimal GitHub Pages site for **The Personalized Computer for the 21st Century**, a half-day in-person UIST 2026 workshop.

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
- `.nojekyll`

That keeps `.omx`, git metadata, and other repository files out of the published artifact.

## Organizer links

The organizers section links only to the verified homepages supplied during implementation:

- Helena Vasconcelos — Harvard SEAS profile
- Dora Zhao — personal site
- Michelle S. Lam — personal site
- Dylan Wootton — personal site
- Omar Shaikh — personal site
- Andy Matuschak — personal site
- Mitchell Gordon — MIT profile
- Michael S. Bernstein — Stanford HCI profile

## Launch checklist

Replace these source placeholders before announcing the site. Until then, the page shows honest “coming soon” and “to be announced” copy:

- `REPLACE_GOOGLE_FORM_URL`
- `REPLACE_APPLICATION_DEADLINE`
- `REPLACE_DECISION_DATE`
- `REPLACE_CONTACT_URL_OR_EMAIL`
- `REPLACE_UIST_2026_URL`
