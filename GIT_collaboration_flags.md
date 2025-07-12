## ✅ Use a Custom Comment Flag: `NOTE`, `HINT`, `MARK`, or `NEXT`

These don't trigger pre-commit hooks or TODO scanners, but are **searchable, consistent**, and friendly for joint dev.

### 🔹 Example:

```python
# NEXT: Continue implementing the retry logic here
```

```java
// HINT: User auth is handled above. Just need to validate tokens here.
```

```bash
# MARK: Verified up to this point. Resume with logging enhancements.
```

---

## ✅ Suggested Flags for Collaboration

| Tag      | Purpose                     | Blocking?          | Example                                      |
| -------- | --------------------------- | ------------------ | -------------------------------------------- |
| `TODO:`  | Work to be done             | ❌ Blocks if hooked | `// TODO: Replace test values with real IDs` |
| `FIXME:` | Broken or incorrect logic   | ❌ Blocks if hooked | `// FIXME: This crashes when x < 0`          |
| `NEXT:`  | Suggested next step for dev | ✅ Push-safe        | `# NEXT: Refactor into separate method`      |
| `NOTE:`  | Helpful context or warning  | ✅ Push-safe        | `// NOTE: This runs only once on init`       |
| `MARK:`  | Just a progress marker      | ✅ Push-safe        | `# MARK: Parsing section complete`           |

---

## ✅ Best Practice for Collaboration

You might also include initials, timestamps, or ticket references:

```python
# NEXT(ioexcept, 2025-07-12): Add AWS IAM validation logic
```

Or tie into GitHub/Jira:

```js
// NEXT: See JIRA-481 for remaining items
```

---

## ✅ Search Strategy (for your teammate)

Let your team grep like this:

```bash
git grep -E 'NEXT|NOTE|MARK'
```

Or in VS Code:

* Use `Ctrl+Shift+F` and search for `NEXT:` across the workspace

---

### 🧠 Pro Tip:

You can even add a Git alias:

```bash
git config --global alias.devflags "!git grep -E 'NEXT|NOTE|MARK'"
```

Then run:

```bash
git devflags
```

