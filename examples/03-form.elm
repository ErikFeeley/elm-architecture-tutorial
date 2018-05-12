module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    }


model : Model
model =
    Model "" "" ""



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Password password ->
            { model | password = password }

        PasswordAgain password ->
            { model | passwordAgain = password }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", placeholder "Name", onInput Name ] []
        , input [ type_ "password", placeholder "Password", onInput Password ] []
        , input [ type_ "password", placeholder "Re-enter Password", onInput PasswordAgain ] []
        , viewValidation model
        ]


viewValidation : Model -> Html msg
viewValidation model =
    let
        errors =
            List.map
                (\error -> li [ style [ ( "color", "red" ) ] ] [ text error ])
                (validatePassword model.password model.passwordAgain)
    in
    ul [] errors


type alias Validation =
    { condition : Bool
    , errorMessage : String
    }


validatePassword : String -> String -> List String
validatePassword pass passAgain =
    let
        validations =
            [ Validation (pass /= passAgain) "Passwords must match"
            , Validation (String.length pass == 0) "You must enter a password"
            , Validation (String.length passAgain == 0) "You must confirm your password"
            ]
    in
    validations
        |> List.filter .condition
        |> List.map .errorMessage
