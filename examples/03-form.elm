module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import String


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { name : String
    , password : String
    , passwordAgain : String
    , submitted : Bool
    , formErrors : List String
    }


init : Model
init =
    Model "" "" "" False []



-- UPDATE


type Msg
    = Name String
    | SetPassword String
    | SetPasswordAgain String
    | Submit


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
        |> List.filterMap
            (\val ->
                if val.condition then
                    Just val.errorMessage
                else
                    Nothing
            )


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        SetPassword password ->
            { model | password = password, formErrors = [] }

        SetPasswordAgain password ->
            { model | passwordAgain = password, formErrors = [] }

        Submit ->
            { model | submitted = True, formErrors = validatePassword model.password model.passwordAgain }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ type_ "text", placeholder "Name", onInput Name ] []
        , input [ type_ "password", placeholder "Password", onInput SetPassword ] []
        , input [ type_ "password", placeholder "Re-enter Password", onInput SetPasswordAgain ] []
        , div []
            [ button [ onClick Submit ] [ text "Submit" ]
            ]
        , viewValidation model.formErrors
        ]


viewValidation : List String -> Html msg
viewValidation formErrors =
    let
        errors =
            formErrors
                |> List.map (\error -> li [ style [ ( "color", "red" ) ] ] [ text error ])
    in
    ul [] errors
