unit Clipper.Core;

(*******************************************************************************
* Author    :  Angus Johnson                                                   *
* Version   :  10.0 (beta) - aka Clipper2                                      *
* Date      :  7 May 2022                                                      *
* Copyright :  Angus Johnson 2010-2022                                         *
* Purpose   :  Core Clipper Library module                                     *
*              Contains structures and functions used throughout the library   *
* License   :  http://www.boost.org/LICENSE_1_0.txt                            *
*******************************************************************************)

{$I Clipper.inc}

interface

uses
  Classes, SysUtils, Math;

type
  PPoint64  = ^TPoint64;
  TPoint64  = record
    X, Y: Int64;
{$IFDEF USINGZ}
    Z: Int64;
{$ENDIF}
  end;

  PPointD   = ^TPointD;
  TPointD   = record
    X, Y: double;
{$IFDEF USINGZ}
    Z: double;
{$ENDIF}
  end;

  //Path: a simple data structure representing a series of vertices, whether
  //open (poly-line) or closed (polygon). Paths may be simple or complex (self
  //intersecting). For simple polygons, consisting of a single non-intersecting
  //path, path orientation is unimportant. However, for complex polygons and
  //for overlapping polygons, various 'filling rules' define which regions will
  //be inside (filled) and which will be outside (unfilled).

  TPath64  = array of TPoint64;
  TPaths64 = array of TPath64;
  TArrayOfPaths = array of TPaths64;

  TPathD = array of TPointD;
  TPathsD = array of TPathD;
  TArrayOfPathsD = array of TPathsD;

  //The most commonly used filling rules for polygons are EvenOdd and NonZero.
  //https://en.wikipedia.org/wiki/Even-odd_rule
  //https://en.wikipedia.org/wiki/Nonzero-rule
  TFillRule = (frEvenOdd, frNonZero, frPositive, frNegative);

  TArrayOfInteger = array of Integer;
  TArrayOfDouble = array of double;

  TRect64 = {$IFDEF RECORD_METHODS}record{$ELSE}object{$ENDIF}
  private
    function GetWidth: Int64; {$IFDEF INLINING} inline; {$ENDIF}
    function GetHeight: Int64; {$IFDEF INLINING} inline; {$ENDIF}
    function GetIsEmpty: Boolean; {$IFDEF INLINING} inline; {$ENDIF}
  public
    Left   : Int64;
    Top    : Int64;
    Right  : Int64;
    Bottom : Int64;
    property Width: Int64 read GetWidth;
    property Height: Int64 read GetHeight;
    property IsEmpty: Boolean read GetIsEmpty;
  end;

  TRectD = {$ifdef RECORD_METHODS}record{$else}object{$endif}
  private
    function GetWidth: double; {$IFDEF INLINING} inline; {$ENDIF}
    function GetHeight: double; {$IFDEF INLINING} inline; {$ENDIF}
    function GetIsEmpty: Boolean; {$IFDEF INLINING} inline; {$ENDIF}
  public
    Left   : double;
    Top    : double;
    Right  : double;
    Bottom : double;
    property Width: double read GetWidth;
    property Height: double read GetHeight;
    property IsEmpty: Boolean read GetIsEmpty;
  end;

  TClipType = (ctNone, ctIntersection, ctUnion, ctDifference, ctXor);

  TPointInPolygonResult = (pipInside, pipOutside, pipOn);

  EClipperLibException = class(Exception);

function Area(const path: TPath64): Double; overload;
function Area(const paths: TPaths64): Double; overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function Area(const path: TPathD): Double; overload;
function Area(const paths: TPathsD): Double; overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function IsClockwise(const path: TPath64): Boolean; overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function IsClockwise(const path: TPathD): Boolean; overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function PointInPolygon(const pt: TPoint64;
  const path: TPath64): TPointInPolygonResult;

function CrossProduct(const pt1, pt2, pt3: TPoint64): double; overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function CrossProduct(const pt1, pt2, pt3: TPointD): double; overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function CrossProduct(vec1x, vec1y, vec2x, vec2y: double): double; overload;
  {$IFDEF INLINING} inline; {$ENDIF}

function DotProduct(const pt1, pt2, pt3: TPoint64): double;
  {$IFDEF INLINING} inline; {$ENDIF}

function Sqr(value: Int64): double; overload;
function DistanceSqr(const pt1, pt2: TPoint64): double; overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function DistanceSqr(const pt1, pt2: TPointD): double; overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function DistanceFromLineSqrd(const pt, linePt1, linePt2: TPoint64): double; overload;
function DistanceFromLineSqrd(const pt, linePt1, linePt2: TPointD): double; overload;

function SegmentsIntersect(const s1a, s1b, s2a, s2b: TPoint64): boolean;

function PointsEqual(const pt1, pt2: TPoint64): Boolean; overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function PointsNearEqual(const pt1, pt2: TPointD; distanceSqrd: double): Boolean;
  {$IFDEF INLINING} inline; {$ENDIF}

{$IFDEF USINGZ}
function Point64(const X, Y: Int64; Z: Int64 = 0): TPoint64; overload;
{$IFDEF INLINING} inline; {$ENDIF}
function Point64(const X, Y: Double; Z: double = 0.0): TPoint64; overload;
{$IFDEF INLINING} inline; {$ENDIF}
function PointD(const X, Y: Double; Z: double = 0.0): TPointD; overload;
{$IFDEF INLINING} inline; {$ENDIF}
{$ELSE}
function Point64(const X, Y: Int64): TPoint64; overload; {$IFDEF INLINING} inline; {$ENDIF}
function Point64(const X, Y: Double): TPoint64; overload; {$IFDEF INLINING} inline; {$ENDIF}
function PointD(const X, Y: Double): TPointD; overload; {$IFDEF INLINING} inline; {$ENDIF}
{$ENDIF}

function Point64(const pt: TPointD): TPoint64; overload; {$IFDEF INLINING} inline; {$ENDIF}
function PointD(const pt: TPoint64): TPointD; overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function Rect64(const left, top, right, bottom: Int64): TRect64; overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function Rect64(const recD: TRectD): TRect64; overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function RectD(const left, top, right, bottom: double): TRectD; overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function RectD(const rec64: TRect64): TRectD; overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function GetBounds(const paths: TArrayOfPaths): TRect64; overload;
function GetBounds(const paths: TPaths64): TRect64; overload;
function GetBounds(const paths: TPathsD): TRectD; overload;

procedure InflateRect(var rec: TRect64; dx, dy: Int64); overload;
  {$IFDEF INLINING} inline; {$ENDIF}
procedure InflateRect(var rec: TRectD; dx, dy: double); overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function  UnionRect(const rec, rec2: TRect64): TRect64; overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function  UnionRect(const rec, rec2: TRectD): TRectD; overload;
  {$IFDEF INLINING} inline; {$ENDIF}

function  RotateRect(const rec: TRect64; angleRad: double): TRect64; overload;
function  RotateRect(const rec: TRectD; angleRad: double): TRectD; overload;
procedure OffsetRect(var rec: TRect64; dx, dy: Int64); overload;
  {$IFDEF INLINING} inline; {$ENDIF}
procedure OffsetRect(var rec: TRectD; dx, dy: double); overload;
  {$IFDEF INLINING} inline; {$ENDIF}

function ScalePoint(const pt: TPoint64; scale: double): TPointD;
  {$IFDEF INLINING} inline; {$ENDIF}

function ScalePath(const path: TPath64; sx, sy: double): TPath64; overload;
function ScalePath(const path: TPathD; sx, sy: double): TPath64; overload;
function ScalePath(const path: TPath64; scale: double): TPath64; overload;
function ScalePath(const path: TPathD; scale: double): TPath64; overload;

function ScalePathD(const path: TPath64; sx, sy: double): TPathD; overload;
function ScalePathD(const path: TPathD; sx, sy: double): TPathD; overload;
function ScalePathD(const path: TPath64; scale: double): TPathD; overload;
function ScalePathD(const path: TPathD; scale: double): TPathD; overload;

function ScalePaths(const paths: TPaths64; sx, sy: double): TPaths64; overload;
function ScalePaths(const paths: TPathsD; sx, sy: double): TPaths64; overload;
function ScalePaths(const paths: TPaths64; scale: double): TPaths64; overload;
function ScalePaths(const paths: TPathsD; scale: double): TPaths64; overload;

function ScalePathsD(const paths: TPaths64; sx, sy: double): TPathsD; overload;
function ScalePathsD(const paths: TPathsD; sx, sy: double): TPathsD; overload;
function ScalePathsD(const paths: TPaths64; scale: double): TPathsD; overload;
function ScalePathsD(const paths: TPathsD; scale: double): TPathsD; overload;

function OffsetPath(const path: TPath64; dx, dy: Int64): TPath64; overload;
function OffsetPath(const path: TPathD; dx, dy: double): TPathD; overload;
function OffsetPaths(const paths: TPaths64; dx, dy: Int64): TPaths64; overload;
function OffsetPaths(const paths: TPathsD; dx, dy: double): TPathsD; overload;

function Paths(const pathsD: TPathsD): TPaths64;
function PathsD(const paths: TPaths64): TPathsD;

function StripDuplicates(const path: TPath64; isClosedPath: Boolean = false): TPath64;
function StripNearDuplicates(const path: TPathD;
  minLenSqrd: double; isClosedPath: Boolean): TPathD;

function ValueBetween(val, end1, end2: Int64): Boolean;
  {$IFDEF INLINING} inline; {$ENDIF}
function ValueEqualOrBetween(val, end1, end2: Int64): Boolean;
  {$IFDEF INLINING} inline; {$ENDIF}

function ReversePath(const path: TPath64): TPath64; overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function ReversePath(const path: TPathD): TPathD; overload;
function ReversePaths(const paths: TPaths64): TPaths64; overload;
  {$IFDEF INLINING} inline; {$ENDIF}
function ReversePaths(const paths: TPathsD): TPathsD; overload;
  {$IFDEF INLINING} inline; {$ENDIF}

procedure AppendPoint(var path: TPath64; const pt: TPoint64); overload;
  {$IFDEF INLINING} inline; {$ENDIF}
procedure AppendPoint(var path: TPathD; const pt: TPointD); overload;
  {$IFDEF INLINING} inline; {$ENDIF}

procedure AppendPath(var paths: TPaths64; const extra: TPath64); overload;
procedure AppendPath(var paths: TPathsD; const extra: TPathD); overload;
procedure AppendPaths(var paths: TPaths64; const extra: TPaths64); overload;
procedure AppendPaths(var paths: TPathsD; const extra: TPathsD); overload;

function ArrayOfPathsToPaths(const ap: TArrayOfPaths): TPaths64;
function GetIntersectPoint(const ln1a, ln1b, ln2a, ln2b: TPoint64): TPointD;

function RamerDouglasPeucker(const path: TPath64; epsilon: double): TPath64; overload;
function RamerDouglasPeucker(const paths: TPaths64; epsilon: double): TPaths64; overload;

const
  MaxInt64    = 9223372036854775807;
  NullRect64  : TRect64 = (left: 0; top: 0; right: 0; Bottom: 0);
  NullRectD   : TRectD = (left: 0; top: 0; right: 0; Bottom: 0);
  Tolerance   : Double = 1.0E-15;

implementation

//------------------------------------------------------------------------------
// TRect64 methods ...
//------------------------------------------------------------------------------

function TRect64.GetWidth: Int64;
begin
  result := right - left;
end;
//------------------------------------------------------------------------------

function TRect64.GetHeight: Int64;
begin
  result := bottom - top;
end;
//------------------------------------------------------------------------------

function TRect64.GetIsEmpty: Boolean;
begin
  result := (bottom <= top) or (right <= left);
end;

//------------------------------------------------------------------------------
// TRectD methods ...
//------------------------------------------------------------------------------

function TRectD.GetWidth: double;
begin
  result := right - left;
end;
//------------------------------------------------------------------------------

function TRectD.GetHeight: double;
begin
  result := bottom - top;
end;
//------------------------------------------------------------------------------

function TRectD.GetIsEmpty: Boolean;
begin
  result := (bottom <= top) or (right <= left);
end;

//------------------------------------------------------------------------------
// Miscellaneous Functions ...
//------------------------------------------------------------------------------

procedure RaiseError(const msg: string); {$IFDEF INLINING} inline; {$ENDIF}
begin
  raise EClipperLibException.Create(msg);
end;
//------------------------------------------------------------------------------

function PointsEqual(const pt1, pt2: TPoint64): Boolean;
begin
  Result := (pt1.X = pt2.X) and (pt1.Y = pt2.Y);
end;
//------------------------------------------------------------------------------

function Sqr(value: Int64): double; overload;
begin
  Result := double(value) * value;
end;
//------------------------------------------------------------------------------

function PointsNearEqual(const pt1, pt2: TPointD; distanceSqrd: double): Boolean;
begin
  Result := System.Sqr(pt1.X - pt2.X) + System.Sqr(pt1.Y - pt2.Y) < distanceSqrd;
end;
//------------------------------------------------------------------------------

function StripDuplicates(const path: TPath64; isClosedPath: Boolean): TPath64;
var
  i,j, len: integer;
begin
  len := length(path);
  SetLength(Result, len);
  if len = 0 then Exit;
  Result[0] := path[0];
  j := 0;
  for i := 1 to len -1 do
    if not PointsEqual(Result[j], path[i]) then
    begin
      inc(j);
      Result[j] := path[i];
    end;
  if isClosedPath and PointsEqual(Result[0], path[j]) then dec(j);
  SetLength(Result, j +1);
end;
//------------------------------------------------------------------------------

function StripNearDuplicates(const path: TPathD;
  minLenSqrd: double; isClosedPath: Boolean): TPathD;
var
  i,j, len: integer;
begin
  len := length(path);
  SetLength(Result, len);
  if len = 0 then Exit;

  Result[0] := path[0];
  j := 0;
  for i := 1 to len -1 do
    if not PointsNearEqual(Result[j], path[i], minLenSqrd) then
    begin
      inc(j);
      Result[j] := path[i];
    end;

  if isClosedPath and
    PointsNearEqual(Result[j], Result[0], minLenSqrd) then dec(j);
  SetLength(Result, j +1);
end;
//------------------------------------------------------------------------------

function ValueBetween(val, end1, end2: Int64): Boolean;
begin
  //nb: accommodates axis aligned between where end1 == end2
  Result := ((val <> end1) = (val <> end2)) and
    ((val > end1) = (val < end2));
end;
//------------------------------------------------------------------------------

function ValueEqualOrBetween(val, end1, end2: Int64): Boolean;
begin
  Result := (val = end1) or (val = end2) or
    (val > end1) = (val < end2);
end;
//------------------------------------------------------------------------------

function ScalePoint(const pt: TPoint64; scale: double): TPointD;
begin
  Result.X := pt.X * scale;
  Result.Y := pt.Y * scale;
{$IFDEF USINGZ}
  Result.Z := pt.Z * scale;
{$ENDIF}
end;
//------------------------------------------------------------------------------

function ScalePath(const path: TPath64; sx, sy: double): TPath64;
var
  i,len: integer;
begin
  if sx = 0 then sx := 1;
  if sy = 0 then sy := 1;
  len := length(path);
  setlength(result, len);
  for i := 0 to len -1 do
  begin
    result[i].X := Round(path[i].X * sx);
    result[i].Y := Round(path[i].Y * sy);
  end;
end;
//------------------------------------------------------------------------------

function ScalePath(const path: TPathD; sx, sy: double): TPath64;
var
  i,j, len: integer;
begin
  if sx = 0 then sx := 1;
  if sy = 0 then sy := 1;
  len := length(path);
  setlength(result, len);
  if len = 0 then Exit;
  j := 1;
  result[0].X := Round(path[0].X * sx);
  result[0].Y := Round(path[0].Y * sy);
  for i := 1 to len -1 do
  begin
    result[j].X := Round(path[i].X * sx);
    result[j].Y := Round(path[i].Y * sy);
    if (result[j].X <> result[j-1].X) or
      (result[j].Y <> result[j-1].Y) then inc(j);
  end;
  setlength(result, j);
end;
//------------------------------------------------------------------------------

function ScalePath(const path: TPath64; scale: double): TPath64;
var
  i,j, len: integer;
begin
  len := length(path);
  setlength(result, len);
  if len = 0 then Exit;
  j := 1;
  result[0].X := Round(path[0].X * scale);
  result[0].Y := Round(path[0].Y * scale);
  for i := 1 to len -1 do
  begin
    result[j].X := Round(path[i].X * scale);
    result[j].Y := Round(path[i].Y * scale);
    if (result[j].X <> result[j-1].X) or
      (result[j].Y <> result[j-1].Y) then inc(j);
  end;
  setlength(result, j);
end;
//------------------------------------------------------------------------------

function ScalePath(const path: TPathD; scale: double): TPath64;
var
  i,len: integer;
begin
  len := length(path);
  setlength(result, len);
  for i := 0 to len -1 do
  begin
    result[i].X := Round(path[i].X * scale);
    result[i].Y := Round(path[i].Y * scale);
  end;
end;
//------------------------------------------------------------------------------

function ScalePaths(const paths: TPaths64; sx, sy: double): TPaths64;
var
  i,len: integer;
begin
  if sx = 0 then sx := 1;
  if sy = 0 then sy := 1;
  len := length(paths);
  setlength(result, len);
  for i := 0 to len -1 do
    result[i] := ScalePath(paths[i], sx, sy);
end;
//------------------------------------------------------------------------------

function ScalePaths(const paths: TPathsD; sx, sy: double): TPaths64;
var
  i,len: integer;
begin
  if sx = 0 then sx := 1;
  if sy = 0 then sy := 1;
  len := length(paths);
  setlength(result, len);
  for i := 0 to len -1 do
    result[i] := ScalePath(paths[i], sx, sy);
end;
//------------------------------------------------------------------------------

function ScalePathD(const path: TPath64; sx, sy: double): TPathD;
var
  i: integer;
begin
  setlength(result, length(path));
  for i := 0 to high(path) do
  begin
    result[i].X := path[i].X * sx;
    result[i].Y := path[i].Y * sy;
  end;
end;
//------------------------------------------------------------------------------

function ScalePathD(const path: TPathD; sx, sy: double): TPathD;
var
  i: integer;
begin
  setlength(result, length(path));
  for i := 0 to high(path) do
  begin
    result[i].X := path[i].X * sx;
    result[i].Y := path[i].Y * sy;
  end;
end;
//------------------------------------------------------------------------------

function ScalePathD(const path: TPath64; scale: double): TPathD;
var
  i: integer;
begin
  setlength(result, length(path));
  for i := 0 to high(path) do
  begin
    result[i].X := path[i].X * scale;
    result[i].Y := path[i].Y * scale;
{$IFDEF USINGZ}
    result[i].Z := path[i].Z * scale;
{$ENDIF}
  end;
end;
//------------------------------------------------------------------------------

function ScalePathD(const path: TPathD; scale: double): TPathD;
var
  i: integer;
begin
  setlength(result, length(path));
  for i := 0 to high(path) do
  begin
    result[i].X := path[i].X * scale;
    result[i].Y := path[i].Y * scale;
{$IFDEF USINGZ}
    result[i].Z := path[i].Z * scale;
{$ENDIF}
  end;
end;
//------------------------------------------------------------------------------

function ScalePathsD(const paths: TPaths64; sx, sy: double): TPathsD;
var
  i,j: integer;
begin
  if sx = 0 then sx := 1;
  if sy = 0 then sy := 1;
  setlength(result, length(paths));
  for i := 0 to high(paths) do
  begin
    setlength(result[i], length(paths[i]));
    for j := 0 to high(paths[i]) do
    begin
      result[i][j].X := (paths[i][j].X * sx);
      result[i][j].Y := (paths[i][j].Y * sy);
    end;
  end;
end;
//------------------------------------------------------------------------------

function ScalePathsD(const paths: TPathsD; sx, sy: double): TPathsD;
var
  i,j: integer;
begin
  if sx = 0 then sx := 1;
  if sy = 0 then sy := 1;
  setlength(result, length(paths));
  for i := 0 to high(paths) do
  begin
    setlength(result[i], length(paths[i]));
    for j := 0 to high(paths[i]) do
    begin
      result[i][j].X := paths[i][j].X * sx;
      result[i][j].Y := paths[i][j].Y * sy;
    end;
  end;
end;
//------------------------------------------------------------------------------

function ScalePaths(const paths: TPaths64; scale: double): TPaths64;
var
  i,j: integer;
begin
  setlength(result, length(paths));
  for i := 0 to high(paths) do
  begin
    setlength(result[i], length(paths[i]));
    for j := 0 to high(paths[i]) do
    begin
      result[i][j].X := Round(paths[i][j].X * scale);
      result[i][j].Y := Round(paths[i][j].Y * scale);
{$IFDEF USINGZ}
      result[i][j].Z := Round(paths[i][j].Z * scale);
{$ENDIF}
    end;
  end;
end;
//------------------------------------------------------------------------------

function ScalePaths(const paths: TPathsD; scale: double): TPaths64;
var
  i,j: integer;
begin
  setlength(result, length(paths));
  for i := 0 to high(paths) do
  begin
    setlength(result[i], length(paths[i]));
    for j := 0 to high(paths[i]) do
    begin
      result[i][j].X := Round(paths[i][j].X * scale);
      result[i][j].Y := Round(paths[i][j].Y * scale);
{$IFDEF USINGZ}
      result[i][j].Z := Round(paths[i][j].Z * scale);
{$ENDIF}
    end;
  end;
end;
//------------------------------------------------------------------------------

function ScalePathsD(const paths: TPaths64; scale: double): TPathsD; overload;
var
  i,j: integer;
begin
  setlength(result, length(paths));
  for i := 0 to high(paths) do
  begin
    setlength(result[i], length(paths[i]));
    for j := 0 to high(paths[i]) do
    begin
      result[i][j].X := paths[i][j].X * scale;
      result[i][j].Y := paths[i][j].Y * scale;
{$IFDEF USINGZ}
      result[i][j].Z := paths[i][j].Z * scale;
{$ENDIF}
    end;
  end;
end;
//------------------------------------------------------------------------------

function ScalePathsD(const paths: TPathsD; scale: double): TPathsD; overload;
var
  i,j: integer;
begin
  setlength(result, length(paths));
  for i := 0 to high(paths) do
  begin
    setlength(result[i], length(paths[i]));
    for j := 0 to high(paths[i]) do
    begin
      result[i][j].X := paths[i][j].X * scale;
      result[i][j].Y := paths[i][j].Y * scale;
{$IFDEF USINGZ}
      result[i][j].Z := paths[i][j].Z * scale;
{$ENDIF}
    end;
  end;
end;
//------------------------------------------------------------------------------

function OffsetPath(const path: TPath64; dx, dy: Int64): TPath64;
var
  i: integer;
begin
  if (dx = 0) and (dy = 0) then
  begin
    result := path; //nb: reference counted
    Exit;
  end;

  setlength(result, length(path));
  for i := 0 to high(path) do
  begin
    result[i].X := path[i].X + dx;
    result[i].Y := path[i].Y + dy;
  end;
end;
//------------------------------------------------------------------------------

function OffsetPath(const path: TPathD; dx, dy: double): TPathD;
var
  i: integer;
begin
  if (dx = 0) and (dy = 0) then
  begin
    result := path; //nb: reference counted
    Exit;
  end;

  setlength(result, length(path));
  for i := 0 to high(path) do
  begin
    result[i].X := path[i].X + dx;
    result[i].Y := path[i].Y + dy;
  end;
end;
//------------------------------------------------------------------------------

function OffsetPaths(const paths: TPaths64; dx, dy: Int64): TPaths64;
var
  i,j: integer;
begin
  if (dx = 0) and (dy = 0) then
  begin
    result := paths; //nb: reference counted
    Exit;
  end;

  setlength(result, length(paths));
  for i := 0 to high(paths) do
  begin
    setlength(result[i], length(paths[i]));
    for j := 0 to high(paths[i]) do
    begin
      result[i][j].X := paths[i][j].X + dx;
      result[i][j].Y := paths[i][j].Y + dy;
    end;
  end;
end;
//------------------------------------------------------------------------------

function OffsetPaths(const paths: TPathsD; dx, dy: double): TPathsD;
var
  i,j: integer;
begin
  setlength(result, length(paths));
  for i := 0 to high(paths) do
  begin
    setlength(result[i], length(paths[i]));
    for j := 0 to high(paths[i]) do
    begin
      result[i][j].X := paths[i][j].X + dx;
      result[i][j].Y := paths[i][j].Y + dy;
    end;
  end;
end;
//------------------------------------------------------------------------------

function Paths(const pathsD: TPathsD): TPaths64;
var
  i,j,len,len2: integer;
begin
  len := Length(pathsD);
  setLength(Result, len);
  for i := 0 to len -1 do
  begin
    len2 := Length(pathsD[i]);
    setLength(Result[i], len2);
    for j := 0 to len2 -1 do
    begin
      Result[i][j].X := Round(pathsD[i][j].X);
      Result[i][j].Y := Round(pathsD[i][j].Y);
    end;
  end;
end;
//------------------------------------------------------------------------------

function PathsD(const paths: TPaths64): TPathsD;
var
  i,j,len,len2: integer;
begin
  len := Length(paths);
  setLength(Result, len);
  for i := 0 to len -1 do
  begin
    len2 := Length(paths[i]);
    setLength(Result[i], len2);
    for j := 0 to len2 -1 do
    begin
      Result[i][j].X := paths[i][j].X;
      Result[i][j].Y := paths[i][j].Y;
    end;
  end;
end;
//------------------------------------------------------------------------------

function ReversePath(const path: TPath64): TPath64;
var
  i, highI: Integer;
begin
  highI := high(path);
  SetLength(Result, highI +1);
  for i := 0 to highI do
    Result[i] := path[highI - i];
end;
//------------------------------------------------------------------------------

function ReversePath(const path: TPathD): TPathD;
var
  i, highI: Integer;
begin
  highI := high(path);
  SetLength(Result, highI +1);
  for i := 0 to highI do
    Result[i] := path[highI - i];
end;
//------------------------------------------------------------------------------

function ReversePaths(const paths: TPaths64): TPaths64;
var
  i, j, highJ: Integer;
begin
  i := length(paths);
  SetLength(Result, i);
  for i := 0 to i -1 do
  begin
    highJ := high(paths[i]);
    SetLength(Result[i], highJ+1);
    for j := 0 to highJ do
      Result[i][j] := paths[i][highJ - j];
  end;
end;
//------------------------------------------------------------------------------

function ReversePaths(const paths: TPathsD): TPathsD;
var
  i, j, highJ: Integer;
begin
  i := length(paths);
  SetLength(Result, i);
  for i := 0 to i -1 do
  begin
    highJ := high(paths[i]);
    SetLength(Result[i], highJ+1);
    for j := 0 to highJ do
      Result[i][j] := paths[i][highJ - j];
  end;
end;
//------------------------------------------------------------------------------

procedure AppendPoint(var path: TPath64; const pt: TPoint64);
var
  len: Integer;
begin
  len := length(path);
  SetLength(path, len +1);
  path[len] := pt;
end;
//------------------------------------------------------------------------------

procedure AppendPoint(var path: TPathD; const pt: TPointD);
var
  len: Integer;
begin
  len := length(path);
  SetLength(path, len +1);
  path[len] := pt;
end;
//------------------------------------------------------------------------------

procedure AppendPath(var paths: TPaths64; const extra: TPath64);
var
  len: Integer;
begin
  len := length(paths);
  SetLength(paths, len +1);
  paths[len] := extra;
end;
//------------------------------------------------------------------------------

procedure AppendPath(var paths: TPathsD; const extra: TPathD);
var
  len: Integer;
begin
  len := length(paths);
  SetLength(paths, len +1);
  paths[len] := extra;
end;
//------------------------------------------------------------------------------

procedure AppendPaths(var paths: TPaths64; const extra: TPaths64);
var
  i, len1, len2: Integer;
begin
  len1 := length(paths);
  len2 := length(extra);
  SetLength(paths, len1 + len2);
  for i := 0 to len2 -1 do
    paths[len1 + i] := extra[i];
end;
//------------------------------------------------------------------------------

procedure AppendPaths(var paths: TPathsD; const extra: TPathsD);
var
  i, len1, len2: Integer;
begin
  len1 := length(paths);
  len2 := length(extra);
  SetLength(paths, len1 + len2);
  for i := 0 to len2 -1 do
    paths[len1 + i] := extra[i];
end;
//------------------------------------------------------------------------------

function ArrayOfPathsToPaths(const ap: TArrayOfPaths): TPaths64;
var
  i,j,k, len, cnt: integer;
begin
  cnt := 0;
  len := length(ap);
  for i := 0 to len -1 do
    inc(cnt, length(ap[i]));
  k := 0;
  setlength(result, cnt);
  for i := 0 to len -1 do
    for j := 0 to length(ap[i]) -1 do
    begin
      result[k] := ap[i][j];
      inc(k);
    end;
end;
//------------------------------------------------------------------------------

{$IFDEF USINGZ}
function Point64(const X, Y: Int64; Z: Int64): TPoint64;
begin
  Result.X := X;
  Result.Y := Y;
  Result.Z := Z;
end;
//------------------------------------------------------------------------------

function Point64(const X, Y: Double; Z: double): TPoint64;
begin
  Result.X := Round(X);
  Result.Y := Round(Y);
  Result.Z := Round(Z);
end;
//------------------------------------------------------------------------------

function PointD(const X, Y: Double; Z: Double): TPointD;
begin
  Result.X := X;
  Result.Y := Y;
  Result.Z := Z;
end;
//------------------------------------------------------------------------------

function Point64(const pt: TPointD): TPoint64;
begin
  Result.X := Round(pt.X);
  Result.Y := Round(pt.Y);
  Result.Z := Round(pt.Z);
end;
//------------------------------------------------------------------------------

function PointD(const pt: TPoint64): TPointD;
begin
  Result.X := pt.X;
  Result.Y := pt.Y;
  Result.Z := pt.Z;
end;
//------------------------------------------------------------------------------

{$ELSE}

function Point64(const X, Y: Int64): TPoint64;
begin
  Result.X := X;
  Result.Y := Y;
end;
//------------------------------------------------------------------------------

function Point64(const X, Y: Double): TPoint64;
begin
  Result.X := Round(X);
  Result.Y := Round(Y);
end;
//------------------------------------------------------------------------------

function PointD(const X, Y: Double): TPointD;
begin
  Result.X := X;
  Result.Y := Y;
end;
//------------------------------------------------------------------------------

function Point64(const pt: TPointD): TPoint64;
begin
  Result.X := Round(pt.X);
  Result.Y := Round(pt.Y);
end;
//------------------------------------------------------------------------------

function PointD(const pt: TPoint64): TPointD;
begin
  Result.X := pt.X;
  Result.Y := pt.Y;
end;
//------------------------------------------------------------------------------
{$ENDIF}

function Rect64(const left, top, right, bottom: Int64): TRect64;
begin
  Result.Left   := left;
  Result.Top    := top;
  Result.Right  := right;
  Result.Bottom := bottom;
end;
//------------------------------------------------------------------------------

function Rect64(const recD: TRectD): TRect64;
begin
  Result.Left   := Floor(recD.left);
  Result.Top    := Floor(recD.top);
  Result.Right  := Ceil(recD.right);
  Result.Bottom := Ceil(recD.bottom);
end;
//------------------------------------------------------------------------------

function RectD(const left, top, right, bottom: double): TRectD;
begin
  Result.Left   := left;
  Result.Top    := top;
  Result.Right  := right;
  Result.Bottom := bottom;
end;
//------------------------------------------------------------------------------

function RectD(const rec64: TRect64): TRectD; overload;
begin
  Result.Left   := rec64.left;
  Result.Top    := rec64.top;
  Result.Right  := rec64.right;
  Result.Bottom := rec64.bottom;
end;
//------------------------------------------------------------------------------

function GetBounds(const paths: TArrayOfPaths): TRect64; overload;
var
  i,j,k: Integer;
  p: PPoint64;
begin
  Result := Rect64(MaxInt64, MaxInt64, -MaxInt64, -MaxInt64);
  for i := 0 to High(paths) do
    for j := 0 to High(paths[i]) do
      if Assigned(paths[i][j]) then
      begin
        p := @paths[i][j][0];
        for k := 0 to High(paths[i][j]) do
        begin
          if p.X < Result.Left then Result.Left := p.X;
          if p.X > Result.Right then Result.Right := p.X;
          if p.Y < Result.Top then Result.Top := p.Y;
          if p.Y > Result.Bottom then Result.Bottom := p.Y;
          inc(p);
        end;
      end;
  if Result.Left > Result.Right then Result := NullRect64;
end;
//------------------------------------------------------------------------------

function GetBounds(const paths: TPaths64): TRect64;
var
  i,j: Integer;
  p: PPoint64;
begin
  Result := Rect64(MaxInt64, MaxInt64, -MaxInt64, -MaxInt64);
  for i := 0 to High(paths) do
    if Assigned(paths[i]) then
    begin
      p := @paths[i][0];
      for j := 0 to High(paths[i]) do
      begin
        if p.X < Result.Left then Result.Left := p.X;
        if p.X > Result.Right then Result.Right := p.X;
        if p.Y < Result.Top then Result.Top := p.Y;
        if p.Y > Result.Bottom then Result.Bottom := p.Y;
        inc(p);
      end;
    end;
  if Result.Left > Result.Right then Result := NullRect64;
end;
//------------------------------------------------------------------------------

function GetBounds(const paths: TPathsD): TRectD;
var
  i,j: Integer;
  p: PPointD;
begin
  Result := RectD(MaxDouble, MaxDouble, -MaxDouble, -MaxDouble);
  for i := 0 to High(paths) do
    if Assigned(paths[i]) then
    begin
      p := @paths[i][0];
      for j := 0 to High(paths[i]) do
      begin
        if p.X < Result.Left then Result.Left := p.X;
        if p.X > Result.Right then Result.Right := p.X;
        if p.Y < Result.Top then Result.Top := p.Y;
        if p.Y > Result.Bottom then Result.Bottom := p.Y;
        inc(p);
      end;
    end;
  if Result.Left >= Result.Right then Result := nullRectD;
end;
//------------------------------------------------------------------------------

procedure InflateRect(var rec: TRect64; dx, dy: Int64);
begin
  dec(rec.Left, dx);
  inc(rec.Right, dx);
  dec(rec.Top, dy);
  inc(rec.Bottom, dy);
end;
//------------------------------------------------------------------------------

procedure InflateRect(var rec: TRectD; dx, dy: double);
begin
  rec.Left := rec.Left - dx;
  rec.Right := rec.Right + dx;
  rec.Top := rec.Top - dy;
  rec.Bottom := rec.Bottom + dy;
end;
//------------------------------------------------------------------------------

procedure RotatePt(var pt: TPointD; const center: TPointD; sinA, cosA: double);
var
  tmpX, tmpY: double;
begin
  tmpX := pt.X-center.X;
  tmpY := pt.Y-center.Y;
  pt.X := tmpX * cosA - tmpY * sinA + center.X;
  pt.Y := tmpX * sinA + tmpY * cosA + center.Y;
end;
//------------------------------------------------------------------------------

function RotateRect(const rec: TRectD; angleRad: double): TRectD;
var
  i: integer;
  sinA, cosA: double;
  cp: TPointD;
  pts: TPathD;
begin
  setLength(pts, 4);
  sinA := Sin(-angleRad);
  cosA := cos(-angleRad);
  cp.X := (rec.Right + rec.Left) / 2;
  cp.Y := (rec.Bottom + rec.Top) / 2;
  pts[0] := PointD(rec.Left, rec.Top);
  pts[1] := PointD(rec.Right, rec.Top);
  pts[2] := PointD(rec.Left, rec.Bottom);
  pts[3] := PointD(rec.Right, rec.Bottom);
  for i := 0 to 3 do RotatePt(pts[i], cp, sinA, cosA);
  result.Left := pts[0].X;
  result.Right := result.Left;
  result.Top := pts[0].Y;
  result.Bottom := result.Top;
  for i := 1 to 3 do
  begin
    if pts[i].X < result.Left then result.Left := pts[i].X;
    if pts[i].Y < result.Top then result.Top := pts[i].Y;
    if pts[i].X > result.Right then result.Right := pts[i].X;
    if pts[i].Y > result.Bottom then result.Bottom := pts[i].Y;
  end;
end;
//------------------------------------------------------------------------------

function RotateRect(const rec: TRect64; angleRad: double): TRect64;
var
  recD: TRectD;
begin
  recD := RectD(rec.Left, rec.Top, rec.Right, rec.Bottom);
  recD := RotateRect(recD, angleRad);
  result.Left := Floor(recD.Left);
  result.Top := Floor(recD.Top);
  result.Right := Ceil(recD.Right);
  result.Bottom := Ceil(recD.Bottom);
end;
//------------------------------------------------------------------------------

procedure OffsetRect(var rec: TRect64; dx, dy: Int64);
begin
  inc(rec.Left, dx); inc(rec.Top, dy);
  inc(rec.Right, dx); inc(rec.Bottom, dy);
end;
//------------------------------------------------------------------------------

procedure OffsetRect(var rec: TRectD; dx, dy: double);
begin
  rec.Left   := rec.Left   + dx;
  rec.Right  := rec.Right  + dx;
  rec.Top    := rec.Top    + dy;
  rec.Bottom := rec.Bottom + dy;
end;
//------------------------------------------------------------------------------

function UnionRect(const rec, rec2: TRect64): TRect64;
begin
  //nb: don't use rec.IsEmpty as this will
  //reject open axis-aligned flat paths
  if (rec.Width <= 0) and (rec.Height <= 0) then result := rec2
  else if (rec2.Width <= 0) and (rec2.Height <= 0) then result := rec
  else
  begin
    result.Left := min(rec.Left, rec2.Left);
    result.Right := max(rec.Right, rec2.Right);
    result.Top := min(rec.Top, rec2.Top);
    result.Bottom := max(rec.Bottom, rec2.Bottom);
  end;
end;
//------------------------------------------------------------------------------

function UnionRect(const rec, rec2: TRectD): TRectD;
begin
  //nb: don't use rec.IsEmpty as this will
  //reject open axis-aligned flat paths
  if (rec.Width <= 0) and (rec.Height <= 0) then result := rec2
  else if (rec2.Width <= 0) and (rec2.Height <= 0) then result := rec
  else
  begin
    result.Left := min(rec.Left, rec2.Left);
    result.Right := max(rec.Right, rec2.Right);
    result.Top := min(rec.Top, rec2.Top);
    result.Bottom := max(rec.Bottom, rec2.Bottom);
  end;
end;
//------------------------------------------------------------------------------

//Areas will be positive when path orientation is clockwise, otherwise they
//will be negative (assuming the REVERSE_ORIENTATION preprocessor define
//corresponds with the display's orientation).
function Area(const path: TPath64): Double;
var
  i, j, highI: Integer;
  d: double;
begin
  Result := 0.0;
  highI := High(path);
  j := highI;
  for i := 0 to highI do
  begin
    d := (path[j].Y - path[i].Y); //needed for Delphi7
    Result := Result + d * (path[j].X + path[i].X);
    j := i;
  end;
{$IFDEF REVERSE_ORIENTATION}
  Result := Result * -0.5;
{$ELSE}
  Result := Result * 0.5;
{$ENDIF}
end;
//------------------------------------------------------------------------------

function Area(const paths: TPaths64): Double;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to High(paths) do
    Result := Result + Area(paths[i]);
end;
//------------------------------------------------------------------------------

function Area(const path: TPathD): Double;
var
  i, j, highI: Integer;
begin
  Result := 0.0;
  highI := High(path);
  j := highI;
  for i := 0 to highI do
  begin
    Result := Result +
      (path[j].X + path[i].X) * (path[j].Y - path[i].Y);
    j := i;
  end;
{$IFDEF REVERSE_ORIENTATION}
  Result := Result * -0.5;
{$ELSE}
  Result := Result * 0.5;
{$ENDIF}
end;
//------------------------------------------------------------------------------

function Area(const paths: TPathsD): Double;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to High(paths) do
    Result := Result + Area(paths[i]);
end;
//------------------------------------------------------------------------------

function IsClockwise(const path: TPath64): Boolean;
begin
  Result := (Area(path) >= 0);
end;
//------------------------------------------------------------------------------

function IsClockwise(const path: TPathD): Boolean;
begin
  Result := (Area(path) >= 0);
end;
//------------------------------------------------------------------------------

function PointInPolygon(const pt: TPoint64;
  const path: TPath64): TPointInPolygonResult;
var
  i, val, cnt: Integer;
  d, d2, d3: Double; //using doubles to avoid possible integer overflow
  ptCurr, ptPrev: TPoint64;
begin
  cnt := Length(path);
  if cnt < 3 then
  begin
    result := pipOutside;
    Exit;
  end;
  Result := pipOn;
  val := 0;
  ptPrev := path[cnt -1];
  for i := 0 to cnt -1 do
  begin
    ptCurr := path[i];
    if (ptPrev.Y = pt.Y) then
    begin
      if (ptPrev.X = pt.X) or ((ptCurr.Y = pt.Y) and
        ((ptPrev.X > pt.X) = (ptCurr.X < pt.X))) then Exit;
    end;

    if ((ptCurr.Y < pt.Y) <> (ptPrev.Y < pt.Y)) then
    begin
      if (ptCurr.X >= pt.X) then
      begin
        if (ptPrev.X > pt.X) then val := 1 - val
        else
        begin
          //d := CrossProduct(ptCurr, pt, ptPrev);
          d2 := (ptCurr.X - pt.X); d3 := (ptPrev.X - pt.X);
          d := d2 * (ptPrev.Y - pt.Y) - d3 * (ptCurr.Y - pt.Y);
          if (d = 0) then Exit;
          if ((d > 0) = (ptPrev.Y > ptCurr.Y)) then val := 1 - val;
        end;
      end else
      begin
        if (ptPrev.X > pt.X) then
        begin
          //d := CrossProduct(ptCurr, pt, ptPrev);
          d2 := (ptCurr.X - pt.X); d3 := (ptPrev.X - pt.X);
          d := d2 * (ptPrev.Y - pt.Y) - d3 * (ptCurr.Y - pt.Y);
          if (d = 0) then Exit;
          if ((d > 0) = (ptPrev.Y > ptCurr.Y)) then val := 1 - val;
        end;
      end;
    end;
    ptPrev := ptCurr;
  end;

  case val of
    -1: result := pipOn;
     1: result := pipInside;
     else result := pipOutside;
  end;
end;
//---------------------------------------------------------------------------

function CrossProduct(const pt1, pt2, pt3: TPoint64): double;
begin
  result := CrossProduct(
    pt2.X - pt1.X, pt2.Y - pt1.Y,
    pt3.X - pt2.X, pt3.Y - pt2.Y);
end;
//------------------------------------------------------------------------------

function CrossProduct(const pt1, pt2, pt3: TPointD): double;
begin
  result := CrossProduct(
    pt2.X - pt1.X, pt2.Y - pt1.Y,
    pt3.X - pt2.X, pt3.Y - pt2.Y);
end;
//------------------------------------------------------------------------------

function CrossProduct(vec1x, vec1y, vec2x, vec2y: double): double;
begin
  result := (vec1x * vec2y - vec1y * vec2x);
end;
//------------------------------------------------------------------------------

function DotProduct(const pt1, pt2, pt3: TPoint64): double;
var
  x1,x2,y1,y2: double; //avoids potential int overflow
begin
  x1 := pt2.X - pt1.X;
  y1 := pt2.Y - pt1.Y;
  x2 := pt3.X - pt2.X;
  y2 := pt3.Y - pt2.Y;
  result := (x1 * x2 + y1 * y2);
end;
//------------------------------------------------------------------------------

function DistanceSqr(const pt1, pt2: TPoint64): double;
begin
  Result := Sqr(pt1.X - pt2.X) + Sqr(pt1.Y - pt2.Y);
end;
//------------------------------------------------------------------------------

function DistanceSqr(const pt1, pt2: TPointD): double;
begin
  Result := System.Sqr(pt1.X - pt2.X) + System.Sqr(pt1.Y - pt2.Y);
end;
//------------------------------------------------------------------------------

function DistanceFromLineSqrd(const pt, linePt1, linePt2: TPoint64): double;
var
  a,b,c: double;
begin
  //perpendicular distance of point (x0,y0) = (a*x0 + b*y0 + C)/Sqrt(a*a + b*b)
  //where ax + by +c = 0 is the equation of the line
  //see https://en.wikipedia.org/wiki/Distance_from_a_point_to_a_line
	a := (linePt1.Y - linePt2.Y);
	b := (linePt2.X - linePt1.X);
	c := a * linePt1.X + b * linePt1.Y;
	c := a * pt.x + b * pt.y - c;
	Result := (c * c) / (a * a + b * b);
end;
//---------------------------------------------------------------------------

function DistanceFromLineSqrd(const pt, linePt1, linePt2: TPointD): double;
var
  a,b,c: double;
begin
	a := (linePt1.Y - linePt2.Y);
	b := (linePt2.X - linePt1.X);
	c := a * linePt1.X + b * linePt1.Y;
	c := a * pt.x + b * pt.y - c;
	Result := (c * c) / (a * a + b * b);
end;
//---------------------------------------------------------------------------

function CleanPath(const path: TPath64): TPath64;
var
  i,j, len: integer;
  prev: TPoint64;
begin
  Result := nil;
  len := Length(path);
  while (len > 2) and
   (CrossProduct(path[len-2], path[len-1], path[0]) = 0) do dec(len);
  SetLength(Result, len);
  if (len < 2) then Exit;
  prev := path[len -1];
  j := 0;
  for i := 0 to len -2 do
  begin
    if CrossProduct(prev, path[i], path[i+1]) = 0 then Continue;
    Result[j] := path[i];
    inc(j);
    prev := path[i];
  end;
  Result[j] := path[len -1];
  SetLength(Result, j+1);
end;
//------------------------------------------------------------------------------

function SegmentsIntersect(const s1a, s1b, s2a, s2b: TPoint64): boolean;
begin
  //nb: result excludes overlapping collinear segments
  result := (CrossProduct(s1a, s2a, s2b) * CrossProduct(s1b, s2a, s2b) < 0) and
    (CrossProduct(s2a, s1a, s1b) * CrossProduct(s2b, s1a, s1b) < 0);
end;
//------------------------------------------------------------------------------

function GetIntersectPoint(const ln1a, ln1b, ln2a, ln2b: TPoint64): TPointD;
var
  m1,b1,m2,b2: double;
begin
  //see http://astronomy.swin.edu.au/~pbourke/geometry/lineline2d/
  if (ln1B.X = ln1A.X) then
  begin
    if (ln2B.X = ln2A.X) then exit; //parallel lines
    m2 := (ln2B.Y - ln2A.Y)/(ln2B.X - ln2A.X);
    b2 := ln2A.Y - m2 * ln2A.X;
    Result.X := ln1A.X;
    Result.Y := m2*ln1A.X + b2;
  end
  else if (ln2B.X = ln2A.X) then
  begin
    m1 := (ln1B.Y - ln1A.Y)/(ln1B.X - ln1A.X);
    b1 := ln1A.Y - m1 * ln1A.X;
    Result.X := ln2A.X;
    Result.Y := m1*ln2A.X + b1;
  end else
  begin
    m1 := (ln1B.Y - ln1A.Y)/(ln1B.X - ln1A.X);
    b1 := ln1A.Y - m1 * ln1A.X;
    m2 := (ln2B.Y - ln2A.Y)/(ln2B.X - ln2A.X);
    b2 := ln2A.Y - m2 * ln2A.X;
    if Abs(m1 - m2) > 1.0E-15 then
    begin
      Result.X := (b2 - b1)/(m1 - m2);
      Result.Y := m1 * Result.X + b1;
    end else
    begin
      Result.X := (ln1a.X + ln1b.X)/2;
      Result.Y := (ln1a.Y + ln1b.Y)/2;
    end;
  end;
end;
//------------------------------------------------------------------------------

function PerpendicDistFromLineSqrd(const pt, line1, line2: TPoint64): double;
var
  a,b,c,d: double;
begin
  a := pt.X - line1.X;
  b := pt.Y - line1.Y;
  c := line2.X - line1.X;
  d := line2.Y - line1.Y;
  if (c = 0) and (d = 0) then
    result := 0 else
    result := System.Sqr(a * d - c * b) / (c * c + d * d);
end;
//------------------------------------------------------------------------------

procedure RDP(const path: TPath64; startIdx, endIdx: integer;
  epsilonSqrd: double; var flags: TArrayOfInteger); overload;
var
  i, idx: integer;
  d, maxD: double;
begin
  idx := 0;
  maxD := 0;
	while (endIdx > startIdx) and
    PointsEqual(path[startIdx], path[endIdx]) do
    begin
      flags[endIdx] := 0;
      dec(endIdx);
    end;
  for i := startIdx +1 to endIdx -1 do
  begin
    //PerpendicDistFromLineSqrd - avoids expensive Sqrt()
    d := PerpendicDistFromLineSqrd(path[i], path[startIdx], path[endIdx]);
    if d <= maxD then Continue;
    maxD := d;
    idx := i;
  end;
  if maxD < epsilonSqrd then Exit;
  flags[idx] := 1;
  if idx > startIdx + 1 then RDP(path, startIdx, idx, epsilonSqrd, flags);
  if endIdx > idx + 1 then RDP(path, idx, endIdx, epsilonSqrd, flags);
end;
//------------------------------------------------------------------------------

function RamerDouglasPeucker(const path: TPath64;
  epsilon: double): TPath64;
var
  i,j, len: integer;
  buffer: TArrayOfInteger;
begin
  len := length(path);
  if len < 5 then
  begin
    result := Copy(path, 0, len);
    Exit;
  end;
  SetLength(buffer, len); //buffer is zero initialized
  buffer[0] := 1;
  buffer[len -1] := 1;
  RDP(path, 0, len -1, System.Sqr(epsilon), buffer);
  j := 0;
  SetLength(Result, len);
  for i := 0 to len -1 do
    if buffer[i] = 1 then
    begin
      Result[j] := path[i];
      inc(j);
    end;
  SetLength(Result, j);
end;
//------------------------------------------------------------------------------

function RamerDouglasPeucker(const paths: TPaths64; epsilon: double): TPaths64;
var
  i, len: integer;
begin
  len := Length(paths);
  SetLength(Result, len);
  for i := 0 to len -1 do
    Result[i] := RamerDouglasPeucker(paths[i], epsilon);
end;
//------------------------------------------------------------------------------
end.

