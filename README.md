# Yahoo! Pigskin Pick'em

This project has been created to track and explore fantasy football data in our fun Yahoo! Pigskin Pick'em league.

## 🚀 Features

- Season-by-season tracking of picks and standings
- Weekly pick analysis and results
- Historical data for multiple seasons

## 🛠️ Prerequisites

- Node.js
- npm
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (for local workflow testing)
- [act CLI tool](https://github.com/nektos/act) (for local GitHub Actions testing)

## 🧪 Testing Workflows

This project includes GitHub Actions workflows that can be tested locally using the [act CLI tool](https://github.com/nektos/act).

### Available Test Commands

- `npm test` - Run all tests and GitHub workflows
- `npm run test:workflows` - Only test GitHub workflows

## 🤖 GitHub Actions

This repository includes the following GitHub Actions workflows:

- **PR Title Check**: Validates PR titles against conventional commit messages
- **Version Bump**: Handles version bumping and changelog generation on merge to main
- **GHCR Cleanup**: Automatically cleans up old GitHub Container Registry images

## Additional Resources

- [Tiebreakers for Pick'em games](https://help.yahoo.com/kb/SLN6629.html#:~:text=For%20any%20week%20where%202,for%20the%20first%20Tiebreak%20Game.)

Please see the [README](./2025-26/README.md) for the [2025-26 season](./2025-26/README.md) for this year's pick'em.
