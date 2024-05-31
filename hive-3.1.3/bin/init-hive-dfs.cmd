@echo off
@rem Licensed to the Apache Software Foundation (ASF) under one or more
@rem contributor license agreements.  See the NOTICE file distributed with
@rem this work for additional information regarding copyright ownership.
@rem The ASF licenses this file to You under the Apache License, Version 2.0
@rem (the "License"); you may not use this file except in compliance with
@rem the License.  You may obtain a copy of the License at
@rem
@rem     http://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.

@rem The purpose of this script is to set warehouse's directories on HDFS

set DEFAULT_WAREHOUSE_DIR=/user/hive/warehouse
set DEFAULT_TMP_DIR=/tmp

set WAREHOUSE_DIR=%DEFAULT_WAREHOUSE_DIR%
set TMP_DIR=%DEFAULT_TMP_DIR%
set HELP=

:ProcessCmdLine
	if [%1]==[] goto :FinishArgs

	if %1==--warehouse-dir (
		set WAREHOUSE_DIR=%2
		shift
		shift
		goto :ProcessCmdLine
	) else if %1==--tmp-dir (
		set TMP_DIR=%2
		shift
		shift
		goto :ProcessCmdLine
	) else if %1==--help (
		set HELP=_help
		shift
		goto :ProcessCmdLine
	) else (
		echo Invalid parameter: %1
        set HELP=_help
	)
	@rem parameter at %1 does not match any option, these are optional params
	goto :FinishArgs
	
:FinishArgs

if defined HELP (
	echo Usage %0 [--warehouse-dir ^<Hive user^>] [--tmp-dir ^<Tmp dir^>]
	echo Default value of warehouse directory is: %DEFAULT_WAREHOUSE_DIR%
	echo Default value of the temporary directory is: %DEFAULT_TMP_DIR%
	exit /b 1
)

@rem check for hadoop in the path
set HADOOP=%HADOOP_HOME%\bin\hadoop.cmd
if not exist %HADOOP% (
	echo "Missing hadoop installation: %HADOOP_HOME% must be set"
	exit /b 1
)

@rem Ensure temp dir exist
call %HADOOP% fs -test -d %TMP_DIR%
if not [%ERRORLEVEL%]==[0] ( 
	echo Creating directory [%TMP_DIR%]
	call %HADOOP% fs -mkdir -p %TMP_DIR%
)

echo Setting writeable group rights for directory [%TMP_DIR%]
call %HADOOP% fs -chmod g+w %TMP_DIR%


@rem Ensure warehouse dir exist
call %HADOOP% fs -test -d %WAREHOUSE_DIR%
if not [%ERRORLEVEL%]==[0] ( 
	echo Creating directory [%WAREHOUSE_DIR%]
	call %HADOOP% fs -mkdir -p %WAREHOUSE_DIR%
)

echo Setting writeable group rights for directory [%WAREHOUSE_DIR%]
call %HADOOP% fs -chmod g+w %WAREHOUSE_DIR%

echo Initialization done.
echo.
echo Please, do not forget to set the following configuration properties in hive-site.xml:
echo hive.metastore.warehouse.dir=%WAREHOUSE_DIR%
echo hive.exec.scratchdir=%TMP_DIR%
