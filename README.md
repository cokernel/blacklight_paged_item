# blacklight_paged_item

This adds pagination to multi-page items in Blacklight.  Documents are
assumed to be part of a multi-page item if they have the same value
for their "parent field" (by default, `:parent_id_s`).  It is assumed
that each page of a multi-page item has a document identifier of the
form `{parent doc id}_{number}` and that documents are numbered
contiguously.

This appends a new partial, `:pagination`, to the show view.  Its
position can be set by setting config.show.partials explicitly.
