### ✅ Option 1: Manually Search for TODOs

This is a simple one-liner:

```bash
git grep -i 'TODO'
```

Or to limit to staged changes only:

```bash
git diff --cached | grep -i 'TODO'
```

---

### ✅ Option 2: Pre-Commit Hook to Block Commits with TODOs

Create `.git/hooks/pre-commit` with this:

```bash
#!/bin/bash
if git diff --cached | grep -i 'TODO'; then
    echo "❌ Commit blocked: TODO found in staged changes."
    exit 1
fi
```

Make it executable:

```bash
chmod +x .git/hooks/pre-commit
```

Now, any commit with a `TODO` in staged code will be blocked until you remove or resolve it.

---

### ✅ Option 3: Git Alias for Fast TODO Scan

Add this alias to your Git config:

```bash
git config --global alias.todo "grep -i TODO"
```

Then use it like:

```bash
git todo
```

---

### ✅ Bonus: Ignore Comments in Certain Languages

If you want to filter out things like commented-out `TODO`s, you can enhance your grep with:

```bash
git grep -i 'TODO' -- '*.py' '*.js' '*.java'
```

Or use `ripgrep` for better language awareness:

```bash
rg 'TODO' --glob '!node_modules/*'
```
