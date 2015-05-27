{type, tagline} = require './config.coffee'

###
# Parse a limited subset of wikitext markup into JSON.
###

# Removes HTML, tables, leading newlines and other cruft
preprocess = (text) ->
  re = /// (?:
    # HACK: ignore some tags w/out deleting
    \</? \s* code \s* \>
    # HTML
    | \< \s*      # html start tag, ignoring whitespace
      (\w*?)      # tag name
      (?:\s.*?)?  # optional attributes
      \>          # close tag
      [^]*?       # enclosed text
      \</         # html end tag
      \s* \1 \s*  # tag name, ignoring whitespace
      \>          # close tag
    # HTML comments
    | \<\!\-\- [^]*? \-\-\>
    # Standalone tags
    | \< [^]*? /\>
    # Tables
    | \{\| [^]*? \|\}
    # Special, {{ }} up to doubly nested
    | \{\{
      (?:
        \{\{ [^]*? \}\}
        | [^]
      )*?
      \}\}

  ) ///g

  text.replace(re, '').trim()

# For types with no special attributes
parseText = (type, text) ->
  text.split(/\s/).map (s) ->
    t: type
    w: s

parseLink = (text) ->
  segs = text.split '|'
  if segs.length > 2
    return [] # TODO: we should handle some of these
  [link, ..., text] = segs
  text.split(/\s/).map (s) ->
    t: type.LINK
    w: s
    link: link

# Primary regexp for parser
punc = '"\'.,;:!?()[\\]{}' # use within [] character class
re = /// ^ \s* (?:
    \[\[     (.*?)  \]\]      # link
  | \=\=\=\= (.*?)  \=\=\=\=  # Title3
  | \=\=\=   (.*?)  \=\=\=    # Title2
  | \=\=     (.*?)  \=\=      # Title1
  | '''      (.*?)  '''       # bold
  | ''       (.*?)  ''        # italic
  | ([#{punc}]+) (?!\S)       # post-punctuation
  | ([#{punc}]+)              # pre-punctuation
  | (\S* [^\s#{punc}])        # word
) ///

parse = (title, text) ->
  # Break down by paragraph / section
  sections = (preprocess text).split '\n'

  tokens = (parseText type.TITLE0, title)
  tokens.push {t: type.NEWLINE}
  tokens = tokens.concat (parseText type.NOTE, tagline)
  tokens.push {t: type.NEWLINE}

  for sec in sections
    # Iteratively match chunks of text
    pos = 0
    end = sec.length
    while (pos < end) and (match = re.exec sec[pos...end])?
      pos += match[0].length
      switch
        when (m = match[1])?
          tokens = tokens.concat (parseLink m)
        when (m = match[2])?
          tokens = tokens.concat (parseText type.TITLE3, m)
        when (m = match[3])?
          tokens = tokens.concat (parseText type.TITLE2, m)
        when (m = match[4])?
          tokens = tokens.concat (parseText type.TITLE1, m)
        when (m = match[5])?
          tokens = tokens.concat (parseText type.BOLD, m)
        when (m = match[6])?
          tokens = tokens.concat (parseText type.ITAL, m)
        when (m = match[7])?
          tokens.push {t: type.POST, w: m}
        when (m = match[8])?
          tokens.push {t: type.PRE, w: m}
        when (m = match[9])?
          tokens.push {t: type.WORD, w: m}
    tokens.push {t: type.NEWLINE}

  return tokens

module.exports = {parse}

