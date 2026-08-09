# Process

- Copy upstream. Do not invent a pattern. Search first-party docs, then official examples, then upstream source, then community repos.
- Use the official tool. Prefer an init CLI to a file you write by hand. If no tool exists, or you are blocked, stop and tell the user.
- Give options, not a decision. Show more than one approach with an upstream example for each. The user picks the structure and the scope.
- Remove what is implicit. Delete an argument that equals the default, a binding used one time, or a block that changes nothing. Use a library function instead of your own.
- Do not stop when the code works. Audit the full repo, not only the diff. Use web search and code search in every pass. Find first-party docs, examples, and standard patterns. Do not guess the correct way. Make the code smaller, more standard, and easier to use. Repeat until an audit finds nothing.
