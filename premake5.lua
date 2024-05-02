workspace "Hazelnut" --�����������
    architecture "x86_64" --����ƽ̨ ֻ��64λ--(x86,x86_64,ARM)

    configurations 
    {
        "Debug",
        "Release",
        "Dist"
    }
--��ʱ���� ���� ���Ŀ¼
--��ϸ������֧�ֵ�tokens �ɲο� [https://github.com/premake/premake-core/wiki/Tokens]
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

IncludeDir={}
IncludeDir["GLFW"] = "Hazelnut/vendor/glfw/include"
IncludeDir["Glad"] = "Hazelnut/vendor/Glad/include"
IncludeDir["ImGui"] = "Hazelnut/vendor/imgui"

include "Hazelnut/vendor/glfw"
include "Hazelnut/vendor/Glad"
include "Hazelnut/vendor/imgui"

project "Hazelnut" --��Ŀ����
    location "Hazelnut" --���·��
    kind "SharedLib" --��������Ŀ��dll��̬��
    language "c++"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")--���Ŀ¼
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")--�м���ʱ�ļ���Ŀ¼

    pchheader "hznpch.h"
    pchsource "Hazelnut/src/hznpch.cpp"

    files--����Ŀ���ļ�
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    links
    {
        "glfw",
        "Glad",
        "ImGui",
        "opengl32.lib"
    }

    includedirs--���Ӱ���Ŀ¼
    {
        "%{prj.name}/src",
        "%{prj.name}/vendor/spdlog/include",
        "%{IncludeDir.GLFW}",
        "%{IncludeDir.Glad}",
        "%{IncludeDir.ImGui}"
    }

    filter "system:windows"--windowsƽ̨������
        cppdialect "c++17"
        staticruntime "On"
        systemversion "latest"

        defines --Ԥ�����
        {
            "HZN_BUILD_DLL",
            "HZN_PLATFORM_WINDOWS",
            "_WINDLL",
            "_UNICODE",
            "UNICODE"
        }

        postbuildcommands -- build����Զ�������
        {
            ("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox") --��������dll�⵽sanbox.exe��ͬһĿ¼��ȥ
        }

    filter "configurations:Debug"
        defines "HZN_DEBUG"
        buildoptions "/MDd"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        defines "HZN_RELEASE"
        buildoptions "/MD"
        runtime "Release"
        optimize "on"

    filter "configurations:Dist"
        defines "HZN_DIST"
        buildoptions "/MD"
        runtime "Release"
        optimize "on"

project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "c++"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files
    {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs
    {
        "Hazelnut/vendor/spdlog/include",
        "Hazelnut/src"
    }

    links
    {
        "Hazelnut"
    }

    filter "system:windows"
        cppdialect "c++17"
        staticruntime "On"
        systemversion "latest"

        defines
        {
            "HZN_PLATFORM_WINDOWS",
            "_UNICODE",
            "UNICODE",
        }

    filter "configurations:Debug"
        defines "HZN_DEBUG"
        buildoptions "/MDd"
        runtime "Debug"
        symbols "on"

    filter "configurations:Release"
        defines "HZN_RELEASE"
        buildoptions "/MD"
        runtime "Release"
        optimize "on"

    filter "configurations:Dist"
        defines "HZN_DIST"
        buildoptions "/MD"
        runtime "Release"
        optimize "on"