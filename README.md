# Action Repository

This is a dummy repository used to trigger GitHub webhooks for testing the webhook receiver application.

## Purpose

This repository is set up to send webhook events to the `webhook-repo` Flask application when the following actions occur:

- **PUSH**: When commits are pushed to any branch
- **PULL_REQUEST**: When pull requests are opened or reopened
- **MERGE**: When pull requests are merged

## Setup

### 1. Create This Repository on GitHub

```bash
# Initialize the repository
git init
echo "# Action Repository for GitHub Webhooks" > README.md
git add README.md
git commit -m "Initial commit"

# Add remote and push
git remote add origin <your-action-repo-url>
git push -u origin main
```

### 2. Configure Webhook

1. Go to repository **Settings** → **Webhooks** → **Add webhook**
2. Configure:
   - **Payload URL**: `https://your-webhook-url.com/webhook` (from ngrok or deployment)
   - **Content type**: `application/json`
   - **Secret**: Your webhook secret (optional but recommended)
   - **Events**: 
     - ✅ Pushes
     - ✅ Pull requests
   - **Active**: ✅ Checked
3. Save the webhook

## Testing Events

### Test PUSH Event

```bash
# Make a change
echo "Test push at $(date)" >> test.txt
git add test.txt
git commit -m "Test push event"
git push origin main
```

### Test PULL_REQUEST Event

```bash
# Create a new branch
git checkout -b feature/test-pr

# Make changes
echo "Test feature" > feature.txt
git add feature.txt
git commit -m "Add test feature"
git push origin feature/test-pr

# Then create a Pull Request on GitHub UI
```

### Test MERGE Event (Brownie Points!)

1. Go to the Pull Request you created
2. Click **Merge pull request**
3. Confirm the merge

This will trigger a MERGE webhook event!

## Webhook Payload Examples

### PUSH Event Payload
```json
{
  "ref": "refs/heads/main",
  "after": "abc123...",
  "pusher": {
    "name": "YourUsername"
  },
  "head_commit": {
    "timestamp": "2021-04-01T21:30:00Z"
  }
}
```

### PULL_REQUEST Event Payload
```json
{
  "action": "opened",
  "pull_request": {
    "number": 1,
    "user": {
      "login": "YourUsername"
    },
    "head": {
      "ref": "feature-branch"
    },
    "base": {
      "ref": "main"
    },
    "created_at": "2021-04-01T09:00:00Z"
  }
}
```

### MERGE Event Payload
```json
{
  "action": "closed",
  "pull_request": {
    "number": 1,
    "merged": true,
    "merged_by": {
      "login": "YourUsername"
    },
    "head": {
      "ref": "feature-branch"
    },
    "base": {
      "ref": "main"
    },
    "merged_at": "2021-04-02T12:00:00Z"
  }
}
```

## Verification

After triggering events, verify they're being received:

1. Check GitHub webhook deliveries:
   - Go to **Settings** → **Webhooks** → Select your webhook
   - Click **Recent Deliveries**
   - Verify response status is `200 OK`

2. Check your webhook application UI:
   - Open `http://your-webhook-url.com`
   - Verify events appear in the list
   - Confirm data is formatted correctly

## Troubleshooting

### Webhook Shows 4xx/5xx Error
- Verify your webhook URL is correct and accessible
- Check webhook secret matches between GitHub and your app
- Review webhook delivery response body for error details

### Events Not Appearing in UI
- Verify MongoDB is running and connected
- Check webhook receiver application logs
- Ensure events are being stored in database

### MERGE Events Not Captured
- Verify webhook is configured for "Pull requests" events
- Ensure you're merging PRs (not just closing them)
- Check webhook payload in GitHub delivery logs

## Sample Workflow

```bash
# 1. Clone this repository
git clone <your-action-repo-url>
cd action-repo

# 2. Create and push changes (triggers PUSH)
echo "Change 1" >> test.txt
git add test.txt
git commit -m "Test change 1"
git push origin main

# 3. Create feature branch (triggers PULL_REQUEST)
git checkout -b feature/new-feature
echo "New feature" >> feature.txt
git add feature.txt
git commit -m "Add new feature"
git push origin feature/new-feature
# Create PR on GitHub

# 4. Merge PR on GitHub (triggers MERGE)
# Go to GitHub and merge the PR
```

## Notes

- Keep this repository minimal - it's just for testing
- You can add dummy files to test different scenarios
- All webhook events will be captured and displayed in real-time
- The webhook receiver polls MongoDB every 15 seconds for updates

## Author

Created for TechStax Developer Assessment
