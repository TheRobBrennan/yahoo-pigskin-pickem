#!/bin/bash

# Function to clean up Docker containers created by act
cleanup_docker_containers() {
  echo "\n🧹 Cleaning up Docker containers..."
  
  # Find and remove any containers created by act
  orphaned_containers=$(docker ps -a --filter "name=act-*" -q)
  
  if [ -n "$orphaned_containers" ]; then
    echo "Found orphaned containers. Removing..."
    docker rm -f $orphaned_containers 2>/dev/null || true
    echo "✅ Containers removed successfully"
  else
    echo "No orphaned containers found"
  fi
}

# Set up trap to clean up containers on script exit (normal or abnormal)
trap cleanup_docker_containers EXIT INT TERM

echo "🧪 Testing GitHub Actions workflows..."
echo ""

echo "📋 Testing PR Title Check workflow..."
echo ""

echo "1. Testing major version bump (breaking change)..."
act pull_request -e .github/test-data/pr-events/major.json -W .github/workflows/pr-title-check.yml --container-architecture linux/amd64 --pull=false --bind
echo ""

echo "2. Testing minor version bump (new feature)..."
act pull_request -e .github/test-data/pr-events/minor.json -W .github/workflows/pr-title-check.yml --container-architecture linux/amd64 --pull=false --bind
echo ""

echo "3. Testing patch version bump (fix)..."
act pull_request -e .github/test-data/pr-events/patch.json -W .github/workflows/pr-title-check.yml --container-architecture linux/amd64 --pull=false --bind
echo ""

echo "4. Testing invalid PR format..."
act pull_request -e .github/test-data/pr-events/invalid.json -W .github/workflows/pr-title-check.yml --container-architecture linux/amd64 --pull=false --bind
echo ""

echo "🔄 Testing Version Bump workflow..."
echo ""
echo "Note: The following tests will show authentication errors - this is expected behavior when testing locally"
echo "These operations require the GitHub Actions environment and will work properly when running in GitHub"
echo ""

echo "Testing version bump functionality..."
act push -e .github/test-data/pr-events/merge.json -W .github/workflows/version-bump.yml --container-architecture linux/amd64 --pull=false --bind -s GITHUB_TOKEN="test-token" -s GPG_PRIVATE_KEY="test-key" -s GPG_PASSPHRASE="test-passphrase"
echo ""

# Add test for our new GPG signing functionality
echo "Testing GPG signing with GitHub Actions bot..."
echo "Note: GPG signing tests will fail locally - this is expected"
act push -e .github/test-data/pr-events/merge-bot-signed.json -W .github/workflows/version-bump.yml --container-architecture linux/amd64 --pull=false --bind -s GITHUB_TOKEN="test-token" -s GPG_PRIVATE_KEY="test-key" -s GPG_PASSPHRASE="test-passphrase"
echo ""

# Test GHCR Cleanup workflow
echo "🧹 Testing GHCR Cleanup workflow..."
echo ""
echo "Testing GHCR Cleanup with dry run..."
act workflow_dispatch -e .github/test-data/pr-events/workflow-dispatch.json -W .github/workflows/ghcr-cleanup.yml --container-architecture linux/amd64 --pull=false --bind -s GITHUB_TOKEN="test-token"
echo ""
