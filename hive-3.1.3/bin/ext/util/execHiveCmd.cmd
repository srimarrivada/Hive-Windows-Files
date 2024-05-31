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

set CLI_JAR=hive-cli-*.jar
set BEELINE_JAR=hive-beeline-*.jar
set CLASS=%1

if not %CLASS:.jar=%==%CLASS% (
	set JAR=%CLASS%
	set CLASS=%2
) else if "%USE_DEPRECATED_CLI%" == "true" (
	set JAR=%CLI_JAR%
) else (
	set JAR=%BEELINE_JAR%
)

pushd %HIVE_LIB%
  
for /f %%a IN ('dir /b %JAR%') do (
	set JAR=%HIVE_LIB%\%%a
)
popd


@rem hadoop 20 or newer - skip the aux_jars option. picked up from hiveconf
call %HADOOP% jar %JAR% %CLASS% %HIVE_OPTS% %HIVEARGS%
goto :EOF
