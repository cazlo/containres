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

from containres.ideasdk.aws.aws_endpoints import AwsEndpoints
from containres.ideasdk.aws.aws_client_provider import AWSClientProviderOptions, AwsClientProvider, AwsServiceEndpoint
from containres.ideasdk.aws.instance_metadata_util import InstanceMetadataUtil
from containres.ideasdk.aws.iam_permission_util import IamPermissionUtil
from containres.ideasdk.aws.ec2_instance_types_db import EC2InstanceTypesDB
from containres.ideasdk.aws.aws_util import AWSUtil
from containres.ideasdk.aws.aws_resources import AwsResources
