# elm-oottp
Elm app inspired by the paper [Out of the Tar Pit](https://github.com/papers-we-love/papers-we-love/blob/master/design/out-of-the-tar-pit.pdf)

The idea is as follows:
1. all code adds complexity, and too much complexity is bad
2. "essential" complexity lives in essential business logic you can't do without
3. "accidental" complexity is everything else
4. essential code should never be aware of or require accidental code
5. (bonus - the relational algebra is a preferred way to represent data)

Given these ideas, I've created a "student course enrollment" app. 

### Important:


[Essential.elm](https://github.com/z5h/elm-oottp/blob/master/src/Essential.elm)  
contains the Essential model and it's operations.
this enables a clean separation of persistence concerns. It has it's own `update : EssentialModel -> Message -> Result String EssentialModel`. 

Note that this will never return a command or enable subscriptions as those are accidental complexities.

[AppTypes.elm](https://github.com/z5h/elm-oottp/blob/master/src/AppTypes.elm)  
contains our `Model` type. It is comprised of an `EssentialModel` and a `UIState`.

Because essential complexity is cleanly separated from accidental complexity, the app can operate in 2 modes "strategies". 
See: [App.elm](https://github.com/z5h/elm-oottp/blob/master/src/App.elm)  
We see  
`strategy : Model -> EssentialModel -> ( Model, Cmd Message )`  
is responsible for taking a model, our updated essential model, adn deciding what to do.  
It can either:
1. update the model
2. send a Cmd representing an essential model diff

In the second case, we imagine this diff goes to an extarnal database, and we are informed of patches coming from the database via subscription.  
Our dummy db (see [here](https://github.com/z5h/elm-oottp/blob/master/app.js)) simply echoes diffs back as patches after a delay to immitate lag.

### Notes:

[ListBackedSet.elm](https://github.com/z5h/elm-oottp/blob/master/src/ListBackedSet.elm)  is simply a way to have a Set interface in Elm without requireing comparability of members.
It's for example purposes only and not recommmended for production code.

[Json.elm](https://github.com/z5h/elm-oottp/blob/master/src/Json.elm)  is our Encoder/Decoder stuff. Not particulary interesting.

[Diff.elm](https://github.com/z5h/elm-oottp/blob/master/src/Diff.elm)  is our Diffing stuff. Not particulary interesting.


