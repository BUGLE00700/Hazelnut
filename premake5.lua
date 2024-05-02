workspace "Hazelnut" --解决方案名称
    architecture "x86_64" --编译平台 只编64位--(x86,x86_64,ARM)

    configurations 
    {
        "Debug",
        "Release",
        "Dist"
    }
--临时变量 定义 输出目录
--详细的所有支持的tokens 可参考 [https://github.com/premake/premake-core/wiki/Tokens]
outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

IncludeDir={}
IncludeDir["GLFW"] = "Hazelnut/vendor/glfw/include"
IncludeDir["Glad"] = "Hazelnut/vendor/Glad/include"
IncludeDir["ImGui"] = "Hazelnut/vendor/imgui"

include "Hazelnut/vendor/glfw"
include "Hazelnut/vendor/Glad"
include "Hazelnut/vendor/imgui"

project "Hazelnut" --项目名称
    location "Hazelnut" --相对路径
    kind "SharedLib" --表明该项目是dll动态库
    language "c++"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")--输出目录
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")--中间临时文件的目录

    pchheader "hznpch.h"
    pchsource "Hazelnut/src/hznpch.cpp"

    files--该项目的文件
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

    includedirs--附加包含目录
    {
        "%{prj.name}/src",
        "%{prj.name}/vendor/spdlog/include",
        "%{IncludeDir.GLFW}",
        "%{IncludeDir.Glad}",
        "%{IncludeDir.ImGui}"
    }

    filter "system:windows"--windows平台的配置
        cppdialect "c++17"
        staticruntime "On"
        systemversion "latest"

        defines --预编译宏
        {
            "HZN_BUILD_DLL",
            "HZN_PLATFORM_WINDOWS",
            "_WINDLL",
            "_UNICODE",
            "UNICODE"
        }

        postbuildcommands -- build后的自定义命令
        {
            ("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox") --拷贝引擎dll库到sanbox.exe的同一目录下去
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