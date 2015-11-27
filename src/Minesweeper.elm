module Minesweeper (
  Board,
  Tile,
  createBoard,
  reveal,
  toGrid,
  expose,
  markTile)
  where

import Array exposing (Array, length)
import Random exposing (generate, initialSeed, int, list)

type alias Board = Array Tile

type alias Tile = {
  id: Int,
  isMine: Bool,
  isMarked: Bool,
  isExposed: Bool
}

newTile : Int -> Tile
newTile id = Tile id False False False

createBoard: Int -> Int -> Board
createBoard size numberOfBombs =
  Array.initialize (size * size) newTile |> addBombs numberOfBombs

expose: Board -> Board
expose board =
  let
    exposeTile tile = {tile | isExposed = True}
  in
    Array.map exposeTile board

addBombs: Int -> Board -> Board
addBombs numberOfBombs board =
  let
    bombPositionGenerator = list numberOfBombs (int 0 (length board))
    (bombPositions, _) = generate bombPositionGenerator (initialSeed 100)
    insertBombs: List(Int) -> Board -> Board
    insertBombs listOfPositions board =
      case listOfPositions of
        [] -> board
        head::tail ->
          let
            currentTile = Array.get head board
          in
            case currentTile of
              Just tile -> insertBombs tail (Array.set head {tile | isMine = True} board)
              Nothing -> board
  in
    insertBombs bombPositions board

toGrid: Board -> List(List Tile)
toGrid board =
  let
    size = Array.length board |> toFloat |> sqrt |> truncate
    partition: List Tile -> List(List Tile)
    partition list =
      if List.length list == size then
        [list]
      else
        [List.take size list] ++ (List.drop size list |> partition)
  in
    Array.toList board |> partition

reveal: Tile -> Board -> Board
reveal tile board = Array.set tile.id {tile | isExposed = True} board

markTile: Tile -> Board -> Board
markTile tile board =
  Array.set tile.id {tile | isMarked = True} board
