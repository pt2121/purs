module Data.Picture (Point (Point), Shape (..), Picture (..), showBounds, Bounds) where

import Prelude

import Data.Foldable

data Point = Point
  { x :: Number
  , y :: Number
  }

showPoint :: Point -> String
showPoint (Point { x = x, y = y }) =
  "(" ++ show x ++ ", " ++ show y ++ ")"

data Shape
  = Circle Point Number
  | Rectangle Point Number Number
  | Line Point Point
  | Text Point String

showShape :: Shape -> String
showShape (Circle c r) =
  "Circle [center: " ++ showPoint c ++ ", radius: " ++ show r ++ "]"
showShape (Rectangle c w h) =
  "Rectangle [center: " ++ showPoint c ++ ", width: " ++ show w ++ ", height: " ++ show h ++ "]"
showShape (Line start end) =
  "Line [start: " ++ showPoint start ++ ", end: " ++ showPoint end ++ "]"
showShape (Text loc text) =
  "Text [location: " ++ showPoint loc ++ ", text: " ++ show text ++ "]"

type Picture = Array Shape

showPicture :: Picture -> Array String
showPicture = map showShape

data Bounds = Bounds
  { top    :: Number
  , left   :: Number
  , bottom :: Number
  , right  :: Number
  }

showBounds :: Bounds -> String
showBounds (Bounds b) =
  "Bounds [top: " ++ show b.top ++
  ", left: "      ++ show b.left ++
  ", bottom: "    ++ show b.bottom ++
  ", right: "     ++ show b.right ++
  "]"

shapeBounds :: Shape -> Bounds
shapeBounds (Circle (Point { x = x, y = y }) r) = Bounds
  { top:    y - r
  , left:   x - r
  , bottom: y + r
  , right:  x + r
  }
shapeBounds (Rectangle (Point { x = x, y = y }) w h) = Bounds
  { top:    y - h / 2.0
  , left:   x - w / 2.0
  , bottom: y + h / 2.0
  , right:  x + w / 2.0
  }
shapeBounds (Line (Point p1) (Point p2)) = Bounds
  { top:    Math.min p1.y p2.y
  , left:   Math.min p1.x p2.x
  , bottom: Math.max p1.y p2.y
  , right:  Math.max p1.x p2.x
  }
shapeBounds (Text (Point { x = x, y = y }) _) = Bounds
  { top:    y
  , left:   x
  , bottom: y
  , right:  x
  }

(\/) :: Bounds -> Bounds -> Bounds
(\/) (Bounds b1) (Bounds b2) = Bounds
  { top:    Math.min b1.top    b2.top
  , left:   Math.min b1.left   b2.left
  , bottom: Math.max b1.bottom b2.bottom
  , right:  Math.max b1.right  b2.right
  }

(/\) :: Bounds -> Bounds -> Bounds
(/\) (Bounds b1) (Bounds b2) = Bounds
  { top:    Math.max b1.top    b2.top
  , left:   Math.max b1.left   b2.left
  , bottom: Math.min b1.bottom b2.bottom
  , right:  Math.min b1.right  b2.right
  }

emptyBounds :: Bounds
emptyBounds = Bounds
  { top:     Global.infinity
  , left:    Global.infinity
  , bottom: -Global.infinity
  , right:  -Global.infinity
  }

infiniteBounds :: Bounds
infiniteBounds = Bounds
  { top:    -Global.infinity
  , left:   -Global.infinity
  , bottom:  Global.infinity
  , right:   Global.infinity
  }

bounds :: Picture -> Bounds
bounds = foldl combine emptyBounds
  where
  combine :: Bounds -> Shape -> Bounds
  combine b shape = shapeBounds shape \/ b

instance showPointInstance :: Show Point where
  show (Point { x = x, y = y }) =
    "(" ++ show x ++ ", " ++ show y ++ ")"

instance showShapeInstance :: Show Shape where
  show (Circle c r) =
    "Circle [center: " ++ show c ++ ", radius: " ++ show r ++ "]"
  show (Rectangle c w h) =
    "Rectangle [center: " ++ show c ++ ", width: " ++ show w ++ ", height: " ++ show h ++ "]"
  show (Line start end) =
    "Line [start: " ++ show start ++ ", end: " ++ show end ++ "]"
  show (Text loc text) =
    "Text [location: " ++ show loc ++ ", text: " ++ show text ++ "]"
