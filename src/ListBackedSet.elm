module ListBackedSet exposing (..)


type alias Set a =
    { list : List a }


{-| Create an empty set.
-}
empty : Set a
empty =
    { list = [] }


{-| Create a set with one value.
-}
singleton : a -> Set a
singleton k =
    { list = [ k ] }


{-| Insert a value into a set.
-}
insert : a -> Set a -> Set a
insert k s =
    s |> remove k |> \s -> { list = k :: s.list }


{-| Remove a value from a set. If the value is not found, no changes are made.
-}
remove : a -> Set a -> Set a
remove k s =
    { list = List.filter ((/=) k) s.list }


{-| Determine if a set is empty.
-}
isEmpty : Set a -> Bool
isEmpty { list } =
    List.isEmpty list


{-| Determine if a value is in a set.
-}
member : a -> Set a -> Bool
member k { list } =
    List.member k list


{-| Determine the number of elements in a set.
-}
size : Set a -> Int
size { list } =
    List.length list


{-| Get the union of two sets. Keep all values.
-}
union : Set a -> Set a -> Set a
union s1 s2 =
    fromList (s1.list ++ s2.list)


{-| Get the intersection of two sets. Keeps values that appear in both sets.
-}
intersect : Set a -> Set a -> Set a
intersect set1 set2 =
    filter ((flip member) set2) set1


{-| Get the difference between the first set and the second. Keeps values
that do not appear in the second set.
-}
diff : Set a -> Set a -> Set a
diff set1 set2 =
    filter (((flip member) set2) >> not) set1


{-| Convert a set into a list, sorted from lowest to highest.
-}
toList : Set a -> List a
toList { list } =
    list


{-| Convert a list into a set, removing any duplicates.
-}
fromList : List a -> Set a
fromList xs =
    List.foldl insert empty xs


{-| Fold over the values in a set, in order from lowest to highest.
-}
foldl : (a -> b -> b) -> b -> Set a -> b
foldl f b { list } =
    List.foldl f b list


{-| Fold over the values in a set, in order from highest to lowest.
-}
foldr : (a -> b -> b) -> b -> Set a -> b
foldr f b { list } =
    List.foldr f b list


{-| Map a function onto a set, creating a new set with no duplicates.
-}
map : (a -> b) -> Set a -> Set b
map f s =
    fromList (List.map f (toList s))


{-| Create a new set consisting only of elements which satisfy a predicate.
-}
filter : (a -> Bool) -> Set a -> Set a
filter p { list } =
    fromList (List.filter p list)


cartesianProduct : List x -> List y -> List ( x, y )
cartesianProduct xs ys =
    let
        withYs x =
            List.map (\y -> ( x, y )) ys
    in
        List.map withYs xs |> List.concat


product : Set x -> Set y -> Set ( x, y )
product xs ys =
    cartesianProduct (toList xs) (toList ys)
        |> fromList


{-| Create two new sets; the first consisting of elements which satisfy a
predicate, the second consisting of elements which do not.
-}
partition : (a -> Bool) -> Set a -> ( Set a, Set a )
partition p { list } =
    let
        ( p1, p2 ) =
            List.partition p list
    in
        ( fromList p1, fromList p2 )
