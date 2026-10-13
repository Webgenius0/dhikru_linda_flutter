/// Utility to convert HTML strings from backend APIs / CMS into clean
/// Markdown that can be rendered using [flutter_markdown].
String htmlToMarkdown(String htmlContent) {
  if (htmlContent.isEmpty) return '';

  String text = htmlContent;

  // Normalize line breaks
  text = text.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

  // Headings: <h1> to <h6>
  text = text.replaceAllMapped(
    RegExp(r'<h1[^>]*>(.*?)<\/h1>', caseSensitive: false, dotAll: true),
    (m) => '\n\n# ${m[1]?.trim()}\n\n',
  );
  text = text.replaceAllMapped(
    RegExp(r'<h2[^>]*>(.*?)<\/h2>', caseSensitive: false, dotAll: true),
    (m) => '\n\n## ${m[1]?.trim()}\n\n',
  );
  text = text.replaceAllMapped(
    RegExp(r'<h3[^>]*>(.*?)<\/h3>', caseSensitive: false, dotAll: true),
    (m) => '\n\n### ${m[1]?.trim()}\n\n',
  );
  text = text.replaceAllMapped(
    RegExp(r'<h4[^>]*>(.*?)<\/h4>', caseSensitive: false, dotAll: true),
    (m) => '\n\n#### ${m[1]?.trim()}\n\n',
  );
  text = text.replaceAllMapped(
    RegExp(r'<h5[^>]*>(.*?)<\/h5>', caseSensitive: false, dotAll: true),
    (m) => '\n\n##### ${m[1]?.trim()}\n\n',
  );
  text = text.replaceAllMapped(
    RegExp(r'<h6[^>]*>(.*?)<\/h6>', caseSensitive: false, dotAll: true),
    (m) => '\n\n###### ${m[1]?.trim()}\n\n',
  );

  // Bold / Strong: <strong> or <b>
  text = text.replaceAllMapped(
    RegExp(r'<(?:strong|b)[^>]*>(.*?)<\/(?:strong|b)>', caseSensitive: false, dotAll: true),
    (m) => '**${m[1]?.trim()}**',
  );

  // Italic / Emphasis: <em> or <i>
  text = text.replaceAllMapped(
    RegExp(r'<(?:em|i)[^>]*>(.*?)<\/(?:em|i)>', caseSensitive: false, dotAll: true),
    (m) => '*${m[1]?.trim()}*',
  );

  // Hyperlinks: <a href="url">text</a>
  text = text.replaceAllMapped(
    RegExp(r"""<a\s+[^>]*?href=["']([^"']+)["'][^>]*>(.*?)<\/a>""", caseSensitive: false, dotAll: true),
    (m) => '[${m[2]?.trim()}](${m[1]?.trim()})',
  );

  // Unordered list items: <li>...</li>
  text = text.replaceAllMapped(
    RegExp(r'<li[^>]*>(.*?)<\/li>', caseSensitive: false, dotAll: true),
    (m) => '\n* ${m[1]?.trim()}\n',
  );

  // Blockquotes: <blockquote>...</blockquote>
  text = text.replaceAllMapped(
    RegExp(r'<blockquote[^>]*>(.*?)<\/blockquote>', caseSensitive: false, dotAll: true),
    (m) => '\n> ${m[1]?.trim()}\n',
  );

  // Paragraphs: <p>...</p>
  text = text.replaceAllMapped(
    RegExp(r'<p[^>]*>(.*?)<\/p>', caseSensitive: false, dotAll: true),
    (m) => '\n\n${m[1]?.trim()}\n\n',
  );

  // Break tags: <br>, <br/>, <br />
  text = text.replaceAll(RegExp(r'<br\s*\/?>', caseSensitive: false), '\n');

  // Strip layout wrapper tags (div, span, ul, ol, etc.)
  text = text.replaceAll(
    RegExp(
      r'<\/?(?:ul|ol|div|span|section|article|main|header|footer|table|thead|tbody|tr|td|th)[^>]*>',
      caseSensitive: false,
    ),
    '\n',
  );

  // Strip any remaining unhandled HTML tags
  text = text.replaceAll(RegExp(r'<[^>]+>'), '');

  // Unescape common HTML entities
  text = text
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'")
      .replaceAll('&apos;', "'");

  // Collapse excess blank lines into maximum 2 newlines
  text = text.replaceAll(RegExp(r'\n{3,}'), '\n\n');

  return text.trim();
}
