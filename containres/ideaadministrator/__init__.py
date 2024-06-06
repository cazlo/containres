#  Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
#  Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance
#  with the License. A copy of the License is located at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  or in the 'license' file accompanying this file. This file is distributed on an 'AS IS' BASIS, WITHOUT WARRANTIES
#  OR CONDITIONS OF ANY KIND, express or implied. See the License for the specific language governing permissions
#  and limitations under the License.

import containres.ideaadministrator_meta
from containres.ideaadministrator.app_protocols import AdministratorContextProtocol
from containres.ideaadministrator.app_props import AdministratorProps

__name__ = containres.ideaadministrator_meta.__name__
__version__ = containres.ideaadministrator_meta.__version__

props = AdministratorProps()
Context = AdministratorContextProtocol