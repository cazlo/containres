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

from containres.ideaclustermanager.app.snapshots.apply_snapshot_data_transformation_from_version.abstract_transformation_from_res_version import (
    TransformationFromRESVersion,
)
from containres.ideadatamodel.snapshots import TableName

from logging import Logger
from typing import Dict, List


class TransformationFromVersion2023_11(TransformationFromRESVersion):

    def transform_data(self, env_data_by_table: Dict[TableName, List], logger = Logger) -> Dict[TableName, List]:
        return env_data_by_table
