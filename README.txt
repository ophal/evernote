Evernote integration
--------------------

Integrates Ophal with Evernote.

FEATURES
- Parse Evernote’s nnex format
- List all notes at path /evernote
- Note page at path /evernote/ID (ID = UpdateSequenceNumber)

DEPENDENCIES
- Nutria Seawolf
- lua-xmlreader

INSTALLATION
Add key 'evernote' to Ophal settings. It should contain following keys:
- 'title' : Heading title of notes list view,
- 'file' : path to nnex file (relative to Ophal's index.cgi).

<code>
settings.evernote = {
  title = [[My evernotes]],
  file = [[../ophal.nnex]],
}

</code>

TODO
- Import notes to local storage,
- .nnex files manager,
- Aggregation. Gather notes from Evernote's web service,
