{*****************************************************************************

  Delphi Encryption Compendium (DEC)
  Version 6.0

  Copyright (c) 2016 - 2018 Markus Humm (markus [dot] humm [at] googlemail [dot] com)
  Copyright (c) 2008 - 2012 Frederik A. Winkelsdorf (winkelsdorf [at] gmail [dot] com)
  Copyright (c) 1999 - 2008 Hagen Reddmann (HaReddmann [at] T-Online [dot] de)
  All rights reserved.

                               *** License ***

  This file is part of the Delphi Encryption Compendium (DEC). The DEC is free
  software being offered under a dual licensing scheme: BSD or MPL 1.1.

  The contents of this file are subject to the Mozilla Public License (MPL)
  Version 1.1 (the "License"); you may not use this file except in compliance
  with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/

  Alternatively, you may redistribute it and/or modify it under the terms of
  the following Berkeley Software Distribution (BSD) license:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice,
       this list of conditions and the following disclaimer.
    2. Redistributions in binary form must reproduce the above copyright
       notice, this list of conditions and the following disclaimer in the
       documentation and/or other materials provided with the distribution.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
  THE POSSIBILITY OF SUCH DAMAGE.

                        *** Export/Import Controls ***

  This is cryptographic software. Even if it is created, maintained and
  distributed from liberal countries in Europe (where it is legal to do this),
  it falls under certain export/import and/or use restrictions in some other
  parts of the world.

  PLEASE REMEMBER THAT EXPORT/IMPORT AND/OR USE OF STRONG CRYPTOGRAPHY
  SOFTWARE OR EVEN JUST COMMUNICATING TECHNICAL DETAILS ABOUT CRYPTOGRAPHY
  SOFTWARE IS ILLEGAL IN SOME PARTS OF THE WORLD. SO, WHEN YOU IMPORT THIS
  PACKAGE TO YOUR COUNTRY, RE-DISTRIBUTE IT FROM THERE OR EVEN JUST EMAIL
  TECHNICAL SUGGESTIONS OR EVEN SOURCE PATCHES TO THE AUTHOR OR OTHER PEOPLE
  YOU ARE STRONGLY ADVISED TO PAY CLOSE ATTENTION TO ANY EXPORT/IMPORT AND/OR
  USE LAWS WHICH APPLY TO YOU. THE AUTHORS OF THE DEC ARE NOT LIABLE FOR ANY
  VIOLATIONS YOU MAKE HERE. SO BE CAREFUL, IT IS YOUR RESPONSIBILITY.

*****************************************************************************}

/// <summary>
///   Contains the base class for all the formatting classes
/// </summary>
unit DECFormatBase;

interface

{$I DECOptions.inc}

uses
  SysUtils, Classes, DECBaseClass, DECUtil;

type
  /// <summary>
  ///   Class reference type of the TDECFormat base class. This is used for
  ///   passing formatting classes as parameters or returning those. This is
  ///   especially useful for the formatting classes, as they only contain
  ///   class functions.
  /// </summary>
  TDECFormatClass = class of TDECFormat;

  /// <summary>
  ///   copy input to output (default format)
  /// </summary>
  TFormat_Copy = class;

  /// <summary>
  ///   Basis for all formatting classes. Not to be instantiated directly.
  /// </summary>
  TDECFormat = class(TDECObject)
  protected
    class procedure DoEncode(const Source; var Dest: TBytes; Size: Integer); virtual;
    class procedure DoDecode(const Source; var Dest: TBytes; Size: Integer); virtual;
    class function DoIsValid(const Data; Size: Integer): Boolean; virtual;
  public
    class function Encode(const Data: RawByteString): RawByteString; overload; deprecated; // please use TBytes variant now
    class function Encode(const Data; Size: Integer): RawByteString; overload; deprecated; // please use TBytes variant now

    /// <summary>
    ///   Calls the internal method which actually does the format conversion.
    /// </summary>
    /// <param name="Data">
    ///   Source data to be converted into the format of this class as Byte Array.
    ///   Empty arrays of size 0 are allowed. They'll simply lead to empty return
    //    arrays as well.
    /// </param>
    /// <returns>
    ///   Data in the format of this formatting algorithm as byte array.
    /// </returns>
    class function Encode(const Data: TBytes): TBytes; overload;
    /// <summary>
    ///   Calls the internal method which actually does the format conversion.
    /// </summary>
    /// <param name="Data">
    ///   Source data to be converted from the format of this class as Byte Array
    ///   into the original byte representation. Empty arrays of size 0 are allowed.
    //    They'll simply lead to empty return arrays as well.
    /// </param>
    /// <returns>
    ///   Data in the original byte format it had before getting encoded with
    ///   this formatting.
    /// </returns>
    class function Decode(const Data: TBytes): TBytes; overload;

    class function IsValid(const Data; Size: Integer): Boolean; overload;
    class function IsValid(const Data: TBytes): Boolean; overload;
    class function IsValid(const Text: RawByteString): Boolean; overload; deprecated; // please use TBytes variant now

    /// <summary>
    ///   Converts the ordinal number of an ASCII char given as byte into the
    ///   ordinal number of the corresponding upper case ASCII char. Works only
    ///   on a-z and works like the System.Pas variant just on bytes instead of chars
    /// </summary>
    /// <param name="b">
    ///   Ordinal ASCII char value to be converted to upper case
    /// </param>
    /// <returns>
    ///   Uppercase ordinal number if the number passed in as parameter belongs to
    ///   a char in the a-z range. Otherwise the number passed in will be returned.
    /// </returns>
    class function UpCaseBinary(b: Byte): Byte;
    /// <summary>
    ///   Looks for the index of a given byte in a byte-array.
    /// </summary>
    /// <param name="Value">
    ///   Byte value to be searched in the array
    /// </param>
    /// <param name="Table">
    ///   Byte-array where the value is searched in
    /// </param>
    /// <param name="Len">
    ///   Maximum index until which the search will be performed. If Len is higher
    ///   than length(Table) the latter will be used as maximum
    /// </param>
    /// <returns>
    ///   Index of the first appearance of the searched value. If it cannot be found
    ///   the result will be -1. The index is 0 based.
    /// </returns>
    class function TableFindBinary(Value: Byte; Table: TBytes; Len: Integer): Integer;
  end;

  /// <summary>
  ///   Formatting class which doesn't apply any transformation to the data
  ///   passed in. It simply copies it from Source to Dest.
  /// </summary>
  TFormat_Copy = class(TDECFormat)
  protected
    /// <summary>
    ///   Copies the data contained in Source into Dest without any conversion
    /// </summary>
    /// <param name="Source">
    ///   Variable from which Size bytes will be copied to Dest
    /// </param>
    /// <param name="Dest">
    ///   Byte-array where Source will be copied into. It will be dimensioned
    ///   to a length of Size internally.
    /// </param>
    /// <param name="Size">
    ///   Number of bytes to copy from Soruce to Dest
    /// </param>
    class procedure DoEncode(const Source; var Dest: TBytes; Size: Integer); override;
    /// <summary>
    ///   Copies the data contained in Source into Dest without any conversion
    /// </summary>
    /// <param name="Source">
    ///   Variable from which Size bytes will be copied to Dest
    /// </param>
    /// <param name="Dest">
    ///   Byte-array where Source will be copied into. It will be dimensioned
    ///   to a length of Size internally.
    /// </param>
    /// <param name="Size">
    ///   Number of bytes to copy from Soruce to Dest
    /// </param>
    class procedure DoDecode(const Source; var Dest: TBytes; Size: Integer); override;
    /// <summary>
    ///   Dummy function to check if Source is valid for this particular format
    /// </summary>
    /// <param name="Data">
    ///   Data to be checked for validity. In this dummy case it will only be
    ///   checked for Size >= 0
    /// </param>
    /// <param name="Size">
    ///   Number of bytes the Source to be checked contains
    /// </param>
    /// <returns>
    ///   true if Size >= 0
    /// </returns>
    class function DoIsValid(const Data; Size: Integer): Boolean; override;
  public
  end;

/// <summary>
///   Returns the passed class type if it is not nil. Otherwise the class type
///   of the TFormat_Copy class is being returned.
/// </summary>
/// <param name="FormatClass">
///   Class type of a formatting class like TFormat_HEX or nil, if no formatting
///   is desired.
/// </param>
/// <returns>
///   Passed class type or TFormat_Copy class type, depending on FormatClass
///   parameter value.
/// </returns>
function ValidFormat(FormatClass: TDECFormatClass = nil): TDECFormatClass;

/// <summary>
///   Searches a registered formatting class by name.
/// </summary>
/// <param name="Name">
///   Unique name of the class to be searched.
/// </param>
/// <returns>
///   Class type, which can be used to create an object isntance from. Raises an
///   EDECClassNotRegisteredException exception if the class cannot be found in
///   the list of registered format classes.
/// </returns>
function FormatByName(const Name: string): TDECFormatClass;
/// <summary>
///   Searches a registered formatting class by identity. The identity is some
///   integer value calculated on the basis of the class name, the length of the
///   name and a fixed prefix and by calculating a CRC32 checksum of this.
/// </summary>
/// <param name="Identity">
///   Unique identity of the class to be searched.
/// </param>
/// <returns>
///   Class type, which can be used to create an object isntance from. Raises an
///   EDECClassNotRegisteredException exception if the class cannot be found in
///   the list of registered format classes.
/// </returns>
function FormatByIdentity(Identity: Int64): TDECFormatClass;

implementation

function ValidFormat(FormatClass: TDECFormatClass = nil): TDECFormatClass;
begin
  if FormatClass <> nil then
    Result := FormatClass
  else
    Result := TFormat_Copy;
end;

function FormatByName(const Name: string): TDECFormatClass;
begin
  Result := TDECFormatClass(DECClassByName(Name, TDECFormat));
end;

function FormatByIdentity(Identity: Int64): TDECFormatClass;
begin
  Result := TDECFormatClass(DECClassByIdentity(Identity, TDECFormat));
end;

{ TDECFormat }

class procedure TDECFormat.DoEncode(const Source; var Dest: TBytes; Size: Integer);
begin
  // C++ does not support virtual static functions thus the base cannot be
  // marked 'abstract'. This is our workaround:
  raise EDECAbstractError.Create(Self);
end;

class procedure TDECFormat.DoDecode(const Source; var Dest: TBytes; Size: Integer);
begin
  // C++ does not support virtual static functions thus the base cannot be
  // marked 'abstract'. This is our workaround:
  raise EDECAbstractError.Create(Self);
end;

class function TDECFormat.DoIsValid(const Data; Size: Integer): Boolean;
begin
  {$IFDEF FPC}
  Result := False; // suppress FPC compiler warning
  {$ENDIF FPC}
  // C++ does not support virtual static functions thus the base cannot be
  // marked 'abstract'. This is our workaround:
  raise EDECAbstractError.Create(Self);
end;

class function TDECFormat.Encode(const Data: RawByteString): RawByteString;
var
  b: TBytes;
begin
  if Length(Data) > 0 then
  begin
    DoEncode(Data[Low(Data)], b, Length(Data) * SizeOf(Data[Low(Data)]));
    Result := BytesToRawString(b);
  end
  else
    SetLength(Result, 0);
end;

class function TDECFormat.Encode(const Data: TBytes): TBytes;
var
  b: TBytes;
begin
  if Length(Data) > 0 then
  begin
    DoEncode(Data[0], b, Length(Data));
    Result := b;
  end
  else
    SetLength(Result, 0);
end;

class function TDECFormat.Decode(const Data: TBytes): TBytes;
var
  b: TBytes;
begin
  if Length(Data) > 0 then
  begin
    DoDecode(Data[0], b, Length(Data));
    Result := b;
  end
  else
    SetLength(Result, 0);
end;

class function TDECFormat.Encode(const Data; Size: Integer): RawByteString;
var
  b: TBytes;
begin
  if Size > 0 then
  begin
    DoEncode(Data, b, Size);
    Result := BytesToRawString(b);
  end
  else
    SetLength(Result, 0);
end;

class function TDECFormat.IsValid(const Data; Size: Integer): Boolean;
begin
  Result := DoIsValid(Data, Size);
end;

class function TDECFormat.IsValid(const Data: TBytes): Boolean;
begin
  Result := (Length(Data) = 0) or (DoIsValid(Data[0], Length(Data)));
end;

class function TDECFormat.IsValid(const Text: RawByteString): Boolean;
begin
  Result := (Length(Text) = 0) or
            (DoIsValid(Text[Low(Text)], Length(Text) * SizeOf(Text[Low(Text)])));
end;

class function TDECFormat.UpCaseBinary(b: Byte): Byte;
begin
  Result := b;
  if Result in [$61..$7A] then
    Dec(Result, $61-$41);
end;

class function TDECFormat.TableFindBinary(Value: Byte; Table: TBytes; Len: Integer): Integer;
var
  i : Integer;
begin
  result := -1;
  i      := 0;
  while (i <= Len) and (i < Length(Table)) do
  begin
    if (Table[i] = Value) then
    begin
      result := i;
      break;
    end;

    inc(i);
  end;
end;

{ TFormat_Copy }

class procedure TFormat_Copy.DoEncode(const Source; var Dest: TBytes; Size: Integer);
begin
  SetLength(Dest, Size);
  if Size <> 0 then
    Move(Source, Dest[0], Size);
end;

class procedure TFormat_Copy.DoDecode(const Source; var Dest: TBytes; Size: Integer);
begin
  SetLength(Dest, Size);
  if Size <> 0 then
    Move(Source, Dest[0], Size);
end;

class function TFormat_Copy.DoIsValid(const Data; Size: Integer): Boolean;
begin
  Result := Size >= 0;
end;

end.