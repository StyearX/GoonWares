local SERVICES = {
	"AccountService","AchievementService","ActivityHistoryEventService","AdService",
	"AnalyticsService","AnimationClipProvider","AnimationFromVideoCreatorService",
	"AnimationFromVideoCreatorStudioService","AnnotationsService",
	"AppLifecycleObserverService","AppRatingPromptService","AppStorageService",
	"AppUpdateService","AssetCounterService","AssetDeliveryProxy","AssetImportService",
	"AssetManagerService","AssetQualityService","AssetService","AudioFocusService",
	"AuroraScriptService","AuroraService","AvatarChatService","AvatarCreationService",
	"AvatarEditorService","AvatarImportService","AvatarSettings","BadgeService",
	"BrowserService","BugReporterService","BulkImportService","CSGDictionaryService",
	"CacheableContentProvider","CalloutService","CaptureService","ChangeHistoryService",
	"ChangeHistoryStreamingService","Chat","CloudCRUDService","ClusterPacketCache",
	"CollaboratorsService","CollectionService","CommerceService","ConfigService",
	"ConfigureServerService","ConnectivityService","ContentProvider","ContextActionService",
	"ControllerService","ConversationalAIAcceptanceService","CookiesService","CoreGui",
	"CoreGuiConfiguration","CorePackages","CoreScriptDebuggingManagerHelper",
	"CoreScriptSyncService","CreationDBService","CreatorStoreService",
	"CrossDMScriptChangeListener","DataModelPatchService","DataStoreService","Debris",
	"DebugSettings","DebuggablePluginWatcher","DebuggerConnectionManager","DebuggerManager",
	"DebuggerUIService","DeviceIdService","DraftsService","DraggerService","EditableService",
	"EncodingService","EventIngestService","ExampleV2Service","ExperienceAuthService",
	"ExperienceNotificationService","ExperienceService","ExperienceStateCaptureService",
	"ExperienceStateRecordingService","ExplorerServiceVisibilityService","FaceAnimatorService",
	"FacialAgeEstimationService","FacialAnimationRecordingService",
	"FacialAnimationStreamingServiceV2","FeatureRestrictionManager","FileManagerService",
	"FlagStandService","FlyweightService","FriendService","GamePassService","GameSettings",
	"GamepadService","GenerationService","GenericChallengeService","Geometry",
	"GeometryService","GroupService","GuiService","GuidRegistryService",
	"HSRDataContentProvider","HapticService","HarmonyService","HeapProfilerService",
	"HeatmapService","HeightmapImporterService","Hopper","HttpRbxApiService","HttpService",
	"ILegacyStudioBridge","IXPService","IncrementalPatchBuilder","InsertService",
	"InstanceExtensionsService","InstanceFileSyncService","InternalSyncService",
	"JointsService","KeyboardService","KeyframeSequenceProvider","LSPFileSyncService",
	"LanguageService","LegacyStudioBridge","Lighting","LinkingService","LiveScriptingService",
	"LiveSyncService","LocalStorageService","LocalizationService","LodDataService",
	"LogReporterService","LogService","LoginService","LuaSettings","LuaWebService",
	"LuauScriptAnalyzerService","MLModelDeliveryService","MLService","MarketplaceService",
	"MatchmakingService","MaterialGenerationService","MaterialService","MemStorageService",
	"MemoryStoreService","MeshContentProvider","MessageBusService","MessagingService",
	"MetaBreakpointManager","MicroProfilerService","ModerationService","MouseService",
	"NetworkClient","NetworkServer","NetworkSettings","NonReplicatedCSGDictionaryService",
	"NotificationService","OmniRecommendationsService","OpenCloudService","PackageService",
	"PackageUIService","PartyEmulatorService","PatchBundlerFileWatch","PathfindingService",
	"PerformanceControlService","PermissionsService","PhysicsService","PhysicsSettings",
	"PlaceAssetIdsService","PlaceStatsService","PlacesService","PlatformCloudStorageService",
	"PlatformFriendsService","PlatformLibraries","PlayerDataService","PlayerEmulatorService",
	"PlayerHydrationService","PlayerViewService","Players","PluginDebugService",
	"PluginGuiService","PluginManagementService","PluginPolicyService","PointsService",
	"PolicyService","ProcessInstancePhysicsService","ProximityPromptService","PublishService",
	"RbxAnalyticsService","RecommendationService","ReflectionService","RemoteCommandService",
	"RemoteCursorService","RemoteDebuggerServer","RenderSettings","ReplicatedFirst",
	"ReplicatedStorage","RibbonNotificationService","RobloxPluginGuiService",
	"RobloxReplicatedStorage","RobloxServerStorage","RolloutValidationService",
	"RomarkRbxAnalyticsService","RomarkService","RtMessagingService","RunService",
	"RuntimeContentService","RuntimeScriptService","SafetyService","ScriptChangeService",
	"ScriptCloneWatcher","ScriptCloneWatcherHelper","ScriptCommitService","ScriptContext",
	"ScriptEditorService","ScriptProfilerService","ScriptRegistrationService","ScriptService",
	"Selection","SelectionHighlightManager","SerializationService","ServerScriptService",
	"ServerStorage","ServiceVisibilityService","SessionCheckService","SessionService",
	"SharedTableRegistry","SlimAnimationReplicationService","SlimContentProvider",
	"SlimReplicationService","SlimService","SmoothVoxelsUpgraderService","SnippetService",
	"SocialService","SolidModelContentProvider","SoundService","SoundShimService",
	"SpawnerService","StartPageService","StarterGui","StarterPack","StarterPlayer",
	"StartupMessageService","Stats","StopWatchReporter","StreamingService","Studio",
	"StudioAssetService","StudioCameraService","StudioData","StudioDeviceEmulatorService",
	"StudioPublishService","StudioScriptDebugEventListener","StudioSdkService",
	"StudioService","StudioTestService","StudioUserService","StudioWidgetsService",
	"StylingService","SystemThemeService","TaskScheduler","TeamCreateData",
	"TeamCreatePublishService","TeamCreateService","Teams","TelemetryService",
	"TeleportService","TemporaryCageMeshProvider","TemporaryScriptService","TestService",
	"TextBoxService","TextChatService","TextService","TextureGenerationService",
	"ThirdPartyUserService","TimerService","ToastNotificationService","TouchInputService",
	"TraceRouteService","TracerService","TutorialService","TweenService","UGCAvatarService",
	"UGCValidationService","UIDragDetectorService","UniqueIdLookupService",
	"UnvalidatedAssetService","UserGameSettings","UserInputService","UserService",
	"UserStorageService","VRService","VRStatusService","VersionControlService",
	"VideoCaptureService","VideoScreenCaptureService","VideoService","VirtualInputManager",
	"VirtualUser","VisibilityCheckDispatcher","Visit","VisualizationModeService",
	"VoiceChatInternal","VoiceChatService","WebSocketService","WebViewService","Workspace",
	"WrapDeformMeshProvider",
}

local SPIED = {
	"Name","Parent","Archivable","ClassName","Enabled","Visible","Active","Connected",
	"Value","Text","UserId","DisplayName","Character","LocalPlayer","TeamColor","IsLoaded",
	"AccountAge","MembershipType","Humanoid","Health","MaxHealth","WalkSpeed","JumpPower",
	"HumanoidRootPart","RootPart","PrimaryPart","MoveDirection","JumpHeight","AutoRotate",
	"BreakJointsOnDeath","PlaceId","GameId","Position","CFrame","Size","Orientation",
	"Rotation","WorldPosition","WorldCFrame","Transparency","Color","BrickColor","Material",
	"Reflectance","Anchored","CanCollide","Massless","CastShadow","IsA","isA",
	"FindFirstChild","WaitForChild","FindFirstChildOfClass","FindFirstChildWhichIsA",
	"FindFirstAncestorOfClass","FindFirstAncestorWhichIsA","IsDescendantOf","IsAncestorOf",
	"GetDescendants","GetChildren","GetService","IsClient","IsServer","IsStudio","IsEdit",
	"IsRunning","HasTag","AddTag","RemoveTag","GetTags","GetAttribute","SetAttribute",
	"GetAttributeChangedSignal","GetPropertyChangedSignal","IsInGroup","GetRankInGroup",
	"UserOwnsGamePassAsync","Clone","Destroy","Remove","Connect","Once","Wait","Fire",
	"InvokeServer","InvokeClient",
}

local spied_set = {}
for _, k in ipairs(SPIED) do spied_set[k] = true end

local ProxyMeta = {}
ProxyMeta.__index = function(t, k)
	local instance = rawget(t, "__instance")
	if instance == nil then return nil end
	local ok, val = pcall(function() return instance[k] end)
	if not ok then return nil end
	if type(val) == "function" then
		return function(_, ...)
			local ok2, res = pcall(val, instance, ...)
			if ok2 then return res end
		end
	end
	if typeof(val) == "Instance" then
		local proxy = setmetatable({}, ProxyMeta)
		rawset(proxy, "__instance", val)
		return proxy
	end
	return val
end
ProxyMeta.__newindex = function(t, k, v)
	local instance = rawget(t, "__instance")
	if instance then pcall(function() instance[k] = v end) end
end
ProxyMeta.__tostring = function(t)
	return tostring(rawget(t, "__instance"))
end

local function spy(instance)
	local proxy = setmetatable({}, ProxyMeta)
	rawset(proxy, "__instance", instance)
	return proxy
end

local export = {}
local loaded, failed = 0, 0

for _, name in ipairs(SERVICES) do
	local ok, svc = pcall(game.GetService, game, name)
	if ok and svc then
		rawset(_G, name, svc)
		export[name] = svc
		loaded = loaded + 1
	else
		failed = failed + 1
	end
end

pcall(function()
	local lp = game:GetService("Players").LocalPlayer
	rawset(_G, "LocalPlayer", lp)
	export.LocalPlayer = lp
end)

pcall(function()
	rawset(_G, "Camera", workspace.CurrentCamera)
	export.Camera = workspace.CurrentCamera
end)

rawset(_G, "spy", spy)
export.spy = spy

print(("[AutoService] %d injected | %d unavailable"):format(loaded, failed))

return export

