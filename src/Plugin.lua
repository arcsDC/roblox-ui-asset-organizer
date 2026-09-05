local Plugin = script.Parent
local Tags = {
    Frame = "UI_Frame",
    TextLabel = "UI_Text",
    TextButton = "UI_Button",
    ImageLabel = "UI_Image",
    ScrollingFrame = "UI_Scroll",
    UICorner = "UI_Corner",
    UIStroke = "UI_Stroke",
    UIGradient = "UI_Gradient",
    UICorner = "UI_Corner",
    UIPadding = "UI_Padding",
    UIScale = "UI_Scale",
    UIListLayout = "UI_List",
    UIGridLayout = "UI_Grid",
    UIAspectRatio = "UI_Aspect",
    UISizeConstraint = "UI_Size",
    UIPage = "UI_Page",
    ViewportFrame = "UI_Viewport",
    CanvasGroup = "UI_Canvas",
    CanvasImage = "UI_CanvasImage",
    CanvasText = "UI_CanvasText",
    CanvasGroup = "UI_Canvas",
    SurfaceGui = "UI_Surface",
    BillboardGui = "UI_Billboard",
    ScreenGui = "UI_Screen",
    SurfaceGui = "UI_Surface",
    BillboardGui = "UI_Billboard",
    ScreenGui = "UI_Screen",
}

local function getTagForInstance(inst)
    local className = inst.ClassName
    if Tags[className] then
        return Tags[className]
    end
    return "UI_Generic"
end

local function applyTagsToInstance(inst)
    local tag = getTagForInstance(inst)
    if not inst:GetTag(tag) then
        inst:AddTag(tag)
    end
    for _, child in ipairs(inst:GetChildren()) do
        applyTagsToInstance(child)
    end
end

local function organizeUIElements(root)
    local uiElements = {}
    for _, inst in ipairs(root:GetDescendants()) do
        if inst:IsA("GuiObject") or inst:IsA("GuiBase2d") or inst:IsA("GuiBase3d") then
            table.insert(uiElements, inst)
        end
    end
    table.sort(uiElements, function(a, b)
        local depthA = 0
        local current = a
        while current ~= root do
            depthA = depthA + 1
            current = current.Parent
        end
        local depthB = 0
        current = b
        while current ~= root do
            depthB = depthB + 1
            current = current.Parent
        end
        if depthA ~= depthB then
            return depthA < depthB
        end
        return a.Name < b.Name
    end)
    return uiElements
end

local function createToolbar()
    local toolbar = Plugin:CreateToolbar("UI Organizer")
    local button = toolbar:CreateButton("Organize UI", "Tags and sorts UI elements in the selected hierarchy", "rbxassetid://4458901886")
    button.Click:Connect(function()
        local selected = Workspace.CurrentSelection
        if #selected == 0 then
            warn("Please select a UI element or container first.")
            return
        end
        for _, inst in ipairs(selected) do
            applyTagsToInstance(inst)
            local organized = organizeUIElements(inst)
            for _, uiInst in ipairs(organized) do
                uiInst.Parent = inst
            end
        end
        print("UI elements organized and tagged.")
    end)
end

createToolbar()
