module Main exposing (Msg(..), init, main, subscriptions, update, view)

import Browser
import Browser.Dom as Dom
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes
import Html.Events
import Html.Keyed as Keyed
import Http
import Json.Decode as Decode
import Json.Decode.Pipeline as PipeDecode
import Json.Encode as Encode
import Task
import Url



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( initModel url key, Cmd.none )


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    }


initModel : Url.Url -> Nav.Key -> Model
initModel url key =
    { key = key
    , url = url
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked request ->
            case request of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ Sub.none ]


view : Model -> Browser.Document Msg
view model =
    { title = "Elm and Browser Extensions"
    , body =
        [ firstPage
        , testArea
        , div []
            [ text <| Debug.toString model
            ]
        ]
    }


firstPage : Html msg
firstPage =
    div
        []
        [ h1 []
            [ text "Elm and Browser Extensions"
            ]
        , p []
            [ text "When browser extensions change the DOM in various ways, elm doesn't work anymore and we got runtime errors."
            ]
        , p []
            [ text "This page simulates the typicall behaviour of extensions so that we can test and emulate the outcome."
            ]
        , h2 []
            [ text "First Findings"
            ]
        , p []
            [ text "After going through all possible browser extenstions I realized, regardless of the extension and it's function, there are always the same kind of DOM manipulations, which causes the problem:"
            , ol []
                [ li []
                    [ text "Adding elements"
                    ]
                , li []
                    [ text "Removing elements"
                    ]
                , li []
                    [ text "Resort elements"
                    ]
                ]
            , p []
                [ text "All of those operations cause specific errors. I think this shows us the root of the problem and therefore possible general solutions."
                , strong []
                    [ text " This way we don't need to race against current and future extensions."
                    ]
                ]
            ]
        , p []
            [ strong [] [ text "No problem causes operations, which change any attributes (class, ids etc) not even when the tag itself changes for example from p to span." ]
            ]
        ]


testArea : Html msg
testArea =
    div []
        [ h2 []
            [ text "Test it"
            ]
        , p []
            [ text "The function of this program: Type in a text and click on check. This area will then we replaced with the result of this check."
            ]
        ]
