# Navigate to your repository
cd ~/Documents/TechStaX-Assignment-ActionRepo

# Make sure we're on main branch and up to date
git checkout main
git pull origin main

# Create or reset test-pr branch
git branch -D test-pr 2>/dev/null || true
git checkout -b test-pr

# Make test changes
echo "Test PR changes - $(date)" > pr_test.txt
git add pr_test.txt
git commit -m "Test PR changes - $(date)"

# Push and set upstream
git push -f -u origin test-pr

echo "✅ Created test PR branch. Please create a PR from test-pr to main on GitHub."

# Create or reset test-merge branch
git checkout main
git branch -D test-merge 2>/dev/null || true
git checkout -b test-merge

# Make test changes
echo "Test merge changes - $(date)" > merge_test.txt
git add merge_test.txt
git commit -m "Test merge changes - $(date)"

# Push and set upstream
git push -f -u origin test-merge

echo "✅ Created test merge branch. Please create and merge a PR from test-merge to main on GitHub."
echo "After merging, the webhook should automatically detect the merge event."