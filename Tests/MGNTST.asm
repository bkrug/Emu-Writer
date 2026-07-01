* Insert a margin in an empty margin list
* Insert a margin-entry at the end of a non-empty list
* Insert a margin-entry at the beginning of a non-empty list
* Insert a margin-entry in between two entries, where this will not create a duplicate
* Attempt to insert a margin-entry that would be identical to the one directly after it. The result is to edit the later entry, leaving the list size unchanged.
* Attempt to insert a margin-entry that would be identical to the one directly before it. The result is to edit the earlier entry, leaving the list size unchanged.
* Edit an existing margin-entry (same paragraph index).
* Edit an existing margin-entry such that it will be identical to the following entry. The result will be to delete the following entry, shrinking the list size by one.
* Edit an existing margin-entry such that it will be identical to the preceding entry. The result will be to delete the later entry, shrinking the list size by one.
* Undo a margin entry insertion that grew the list size.  (create an entry)
* Undo a margin entry insertion that really just edit a later entry to point to the current paragraph.  (edit an entry)
* Undo a margin entry edit.  (edit current entry)
* Undo a margin entry edit resulted in deleting a later margin entry.   (edit current entry, delete next entry)
* Undo a margin entry edit that resulted in mergin (deleting) that entry into an earlier entry.    (delete the current entry)