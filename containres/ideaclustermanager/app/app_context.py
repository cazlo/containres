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
from containres.ideasdk.context import SocaContext, SocaContextOptions
from containres.ideasdk.auth import TokenService, ApiAuthorizationServiceBase
from containres.ideasdk.utils import GroupNameHelper
from containres.ideasdk.client.vdc_client import AbstractVirtualDesktopControllerClient

from containres.ideaclustermanager.app.projects.projects_service import ProjectsService
from containres.ideaclustermanager.app.accounts.accounts_service import AccountsService
from containres.ideaclustermanager.app.adsync.adsync_service import ADSyncService
from containres.ideaclustermanager.app.snapshots.snapshots_service import SnapshotsService
from containres.ideaclustermanager.app.accounts.cognito_user_pool import CognitoUserPool
from containres.ideaclustermanager.app.accounts.ldapclient import OpenLDAPClient, ActiveDirectoryClient
from containres.ideaclustermanager.app.accounts.ad_automation_agent import ADAutomationAgent
from containres.ideaclustermanager.app.email_templates.email_templates_service import EmailTemplatesService
from containres.ideaclustermanager.app.notifications.notifications_service import NotificationsService
from containres.ideaclustermanager.app.shared_filesystem.shared_filesystem_service import SharedFilesystemService
from containres.ideaclustermanager.app.tasks.task_manager import TaskManager

from typing import Optional, Union


class ClusterManagerAppContext(SocaContext):

    def __init__(self, options: SocaContextOptions):
        super().__init__(
            options=options
        )

        self.token_service: Optional[TokenService] = None
        self.api_authorization_service: Optional[ApiAuthorizationServiceBase] = None
        self.projects: Optional[ProjectsService] = None
        self.user_pool: Optional[CognitoUserPool] = None
        self.ldap_client: Optional[Union[OpenLDAPClient, ActiveDirectoryClient]] = None
        self.accounts: Optional[AccountsService] = None
        self.task_manager: Optional[TaskManager] = None
        self.ad_automation_agent: Optional[ADAutomationAgent] = None
        self.email_templates: Optional[EmailTemplatesService] = None
        self.notifications: Optional[NotificationsService] = None
        self.group_name_helper: Optional[GroupNameHelper] = None
        self.snapshots: Optional[SnapshotsService] = None
        self.ad_sync: Optional[ADSyncService] = None
        self.vdc_client: Optional[AbstractVirtualDesktopControllerClient] = None
        self.shared_filesystem: Optional[SharedFilesystemService]
