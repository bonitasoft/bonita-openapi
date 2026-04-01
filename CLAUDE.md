# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository defines the **Bonita Platform web API** using the OpenAPI v3 specification (YAML). It is the single source of truth for Bonita features accessible through HTTP. The spec is split across many files using `$ref` references and assembled by Redocly CLI into a single bundled file.

## Commands

- **Install dependencies:** `npm install` (or `npm ci` for CI-reproducible installs)
- **Lint/validate the spec:** `npm test` (runs `redocly lint`)
- **Preview docs (ReDoc):** `npm start` (serves at http://localhost:8080)
- **Bundle spec to single file:** `npm run yaml` (outputs to `dist/openapi.yaml`)
- **Generate Postman collection:** `npm run postman` (requires bundled spec in dist/)
- **Full build (lint + bundle + postman + static docs + zip):** `npm run package`

Node.js 18 is used in CI.

## Repository Structure

- `openapi/openapi.yaml` — Root spec file; defines servers, security, tag groups, and all path references. Paths are organized by functional sections with comment headers (`# BPM API`, `# IDENTITY API`, etc.)
- `openapi/paths/` — One YAML file per endpoint
- `openapi/components/schemas/` — Reusable schema definitions (one per type)
- `openapi/components/parameters/` — Reusable pagination params: `pageIndex` (`p`), `pageCount` (`c`), `pageFilter` (`f`), `pageOrder` (`o`), `pageSearch` (`s`); plus auth cookies (`jsessionId`, `csrfToken`)
- `openapi/components/responses/` — Standard error responses: `Unauthorized` (401), `Forbidden` (403), `BadRequest` (400), `NotFound` (404), `ServerError` (5XX), `OK`, `NoContent`
- `openapi/templates/` — Scaffolding templates for new endpoints (see "Adding a New Endpoint" below)
- `openapi/intro.md` — API introduction (referenced from openapi.yaml description)
- `docs/` — Static doc assets (HTML template in `index.html.hbs`, images)
- `.redocly.yaml` — Redocly CLI config; lint rules extend `recommended`, `no-unused-components` set to warn

## Adding a New Endpoint

Two templates in `openapi/templates/` provide scaffolding — copy and replace `XXX` placeholders:

1. **`get.tpl.yaml`** — Single resource: GET/PUT/DELETE by ID. operationIds: `getXXXById`, `updateXXXById`, `deleteXXXById`
2. **`list.tpl.yaml`** — Collection: GET (with pagination) + POST. operationIds: `findXXXs`, `createXXX`. GET includes `Content-Range` header for total count and refs to all five pagination parameters.

Steps:
1. Create schema file(s) in `openapi/components/schemas/`
2. Create path file in `openapi/paths/` using the `@` naming convention
3. Add the path entry in `openapi/openapi.yaml` under the appropriate section
4. Add/reuse a tag and assign it to a tag group in `openapi/openapi.yaml`
5. Run `npm test` to validate

## Naming Conventions

**Path files:** URL path with `/` replaced by `@`, path params preserved in `{braces}`:
- `/API/bpm/case/{id}` → `API@bpm@case@{id}.yaml`

**operationIds** follow verb+noun pattern:
- Single resource: `getXXXById`, `updateXXXById`, `deleteXXXById`
- Collections: `searchXXXs` or `findXXXs` (GET), `createXXX` (POST)
- Batch: `deleteXXXByIds`
- Special: `uploadProcess`, `broadcastSignal`

**Responses:** All endpoints should use `$ref` to shared responses in `components/responses/`. Standard set: 401 Unauthorized, 400 BadRequest, 404 NotFound (single resource), 5XX ServerError.

## Key Conventions

- YAML format preferred over JSON for multiline description support
- Descriptions use markdown; the spec is documentation-heavy by design
- OpenAPI extensions (`x-logo`, `x-codeSamples`, `x-tagGroups`) are used for enhanced doc rendering
- Compose schemas using `$ref` to avoid duplication
- PRs target `master` branch (GitHub flow)
- PR labels (`enhancement`, `bug`) control release note sections; use `ignore-for-release-notes` to exclude
- Releases are triggered manually via GitHub Actions (`patch`/`minor`/`major`), auto-update version across `package.json`, `package-lock.json`, and `openapi.yaml`, and trigger downstream `bonita-java-client` generation
