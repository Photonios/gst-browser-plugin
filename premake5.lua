-- Set up names of environment variables we need
local gstreamer_env = "GSTREAMER_1_0_ROOT_X86"

-- Generate files
os.execute("glib-genmarshal --header --prefix=gbp_marshal src\\gbp-marshal.list > src\\gbp-marshal.h")
os.execute("glib-genmarshal --body --prefix=gbp_marshal src\\gbp-marshal.list > src\\gbp-marshal.c")

solution "gst-browser-plugin"
	configurations { "Debug", "Release" }
	startproject "gst-browser-plugin"
	
	project "gst-browser-plugin"
		kind "SharedLib"
		language "C++"
		location "proj"
		targetdir "bin"
		targetname "nplibgbp"
		files { 
			path.project("src/**.h"),
			path.project("src/**.c"),
			path.project("src/**.def"),
			path.project("src/**.rc")
		}
		links { 
			"glib-2.0.lib",
			"gobject-2.0.lib",
			"gstreamer-1.0.lib",
			"gstrtspserver-1.0.lib",
			"gstvideo-1.0.lib"
		}
		includedirs  { 
			path.project("src"),
			path.from_env(gstreamer_env, "dep/gstreamer", "include"),
			path.from_env(gstreamer_env, "dep/gstreamer", "include/gstreamer-1.0"),
			path.from_env(gstreamer_env, "dep/gstreamer", "include/glib-2.0"),
			path.from_env(gstreamer_env, "dep/gstreamer", "lib/glib-2.0/include")
		}
		libdirs { 
			path.from_env(gstreamer_env, "dep/gstreamer", "lib")
		}

		configuration "Debug"
			defines { "DEBUG" }
			flags { "Symbols" }

		configuration "Release"
			defines { "NDEBUG" }
			optimize "Speed"

		configuration { "linux", "gmake" }
			buildoptions "-std=c++11"

		configuration { "windows" }
			defines {
				"_WINSOCK_DEPRECATED_NO_WARNINGS",
				"_SCL_SECURE_NO_WARNINGS",
				"_CRT_SECURE_NO_WARNINGS",
				"_WIN32_WINNT=0x0501",
				"XP_WIN",
				"_WINDOWS"
			}