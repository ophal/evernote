Evernote integration
--------------------

Integrates Ophal with Evernote.

FEATURES
- Parse Evernote’s nnex format
- List all notes at path /evernote
- Note page at path /evernote/ID (ID = UpdateSequenceNumber)

DEPENDENCIES
- Seawolf contrib
- lua-xmlreader

INSTALLATION
Add key 'evernote' to settings. It should contain following keys:
- 'title' = 'Title'
- 'file' = path to nnex file (relative to Ophal's index.cgi)

<code>
settings.evernote = {
  title = [[Latest news]],
  file = [[../ophal.nnex]],
}
</code>

TODO
- Gather notes from Evernote's web service,
- Remote notes cache,
- Support several nnex files, each with its own url.