# languamunity
A command-line user-end program for the LanguaMunity system

# Some Surface-Level Subcommands

## git

    languamunity git [localname] [url]

Initializes a new local taking of the course who's GIT bare-repository
is at _\[url\]_, giving it the local-name _\[localname\]_.

It then sets the newly created course-taking as the Standing Default for
the current Languamunity user.

## reinit

    languamunity reinit [localname]

Completely re-initializes the already-existing course-taking
who's local name is _\[localname\]_.

Remember - this means that any lesson that previously was on
your belt will now need to be re-added.

After reinitializing the course-taking,
this command sets the newly reinitialized
course-taking as the Standing Default for
the current Languamunity user.

## select

    languamunity select [localname]

This command simply selects the house named _\[localname\]_
as the Standing Default.

This requires a pre-existing house for that purpose.
(See __languamunity git__ to learn how to create one.)

## eligible

    languamunity eligible

Lists the lessons (by lesson code-ID) that
can be added next time the current Languamunity
user adds a lesson to the belt of the current
Standing Default.

## quiz

    languamunity quiz

Begin a five-minute flashcard session.

## houses

    languamunity houses

Lists the "houses" that the current Languamunity user
has on their account.
(A "house" is a term sometimes used to refer to a local
taking of a remote course.)

## addlcn

    languamunity addlcn [lcnid]

Adds to the belt the lesson who's lesson ID-code is _\[lcnid\]_.

## update

    languamunity update

Updates the contents of the course on the current
House.
All old flash-cards (including any pending rehashes
of previously-missed cards) will be cleared away
to avoid potential conflicts with the updated
course - but the lessons on the belt will remain
listed and therefore do not need to be re-added.
