# Explain Hunk

Display and explain the last git hunk that was sent to Claude for analysis or assistance.

## Analysis Tasks:

1. **Retrieve Last Hunk Context**
   - Show the last git diff/hunk that was shared with Claude
   - Include the file path and line numbers for context
   - Display the actual changes (additions/deletions)

2. **Code Analysis**
   - Explain what the code changes do functionally
   - Identify the purpose and intent behind the modifications
   - Note any patterns, best practices, or potential issues
   - Explain the technical implementation details

3. **Impact Assessment**
   - Describe how these changes affect the overall codebase
   - Identify any potential side effects or dependencies
   - Note if this relates to bug fixes, new features, or refactoring
   - Assess the scope and significance of the changes

4. **Context and Rationale**
   - Explain why these changes might have been made
   - Identify the problem being solved or feature being added
   - Note any architectural or design patterns being followed
   - Suggest related areas that might need attention

## Output Format:

**🔍 Hunk Details**
- File path and line numbers
- Summary of what changed (additions, deletions, modifications)

**⚙️ Functional Explanation**
- What the code does and how it works
- Technical implementation details
- Key logic and algorithms involved

**🎯 Purpose and Impact**
- Why these changes were likely made
- How they affect the broader codebase
- Potential implications and considerations

**💡 Additional Insights**
- Code quality observations
- Suggestions for related improvements
- Best practices and patterns observed

Keep the explanation technical but accessible, focusing on helping understand both the "what" and "why" of the code changes.