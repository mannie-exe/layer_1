# Local GitHub Actions Testing with `act`

## Quick Commands

```bash
# Install act (macOS)
brew install act

# List all workflows and jobs
act -l

# Dry run (show what would execute)
act -n

# Test validation workflow (PR simulation)
act pull_request -n -e .github/act-events/pull_request.json

# Test release workflow (tag simulation) 
act push -n -e .github/act-events/tag.json

# Actually run validation (for real testing)
act pull_request -e .github/act-events/pull_request.json

# Test specific job only
act -j validate -n
act -j build -n
```

## Event Files

- `.github/act-events/push.json` - Regular push events
- `.github/act-events/tag.json` - Release tag events  
- `.github/act-events/pull_request.json` - PR events

## Configuration

- `.actrc` - Default act configuration
  - Uses improved Ubuntu images
  - Enables container reuse for speed
  - Sets default push event
  - Enables offline mode

## Notes

- Add `--container-architecture linux/amd64` if you have issues on Apple Silicon
- First run will be slower (pulling Docker images)
- Subsequent runs are much faster with `--reuse`
- Use `-n` flag for dry runs before real execution