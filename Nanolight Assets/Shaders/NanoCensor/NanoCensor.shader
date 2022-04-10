// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Nanolight/Censor"
{
	Properties
	{
		_Pixelation("Pixelation", Int) = 50
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Overlay"  "Queue" = "Overlay-100" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		ZWrite Off
		GrabPass{ }
		CGPROGRAM
		#pragma target 5.0
		#if defined(UNITY_STEREO_INSTANCING_ENABLED) || defined(UNITY_STEREO_MULTIVIEW_ENABLED)
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex);
		#else
		#define ASE_DECLARE_SCREENSPACE_TEXTURE(tex) UNITY_DECLARE_SCREENSPACE_TEXTURE(tex)
		#endif
		#pragma surface surf Unlit keepalpha noshadow exclude_path:deferred 
		struct Input
		{
			float4 screenPos;
		};

		ASE_DECLARE_SCREENSPACE_TEXTURE( _GrabTexture )
		uniform int _Pixelation;


		inline float4 ASE_ComputeGrabScreenPos( float4 pos )
		{
			#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
			#else
			float scale = 1.0;
			#endif
			float4 o = pos;
			o.y = pos.w * 0.5f;
			o.y = ( pos.y - o.y ) * _ProjectionParams.x * scale + o.y;
			return o;
		}


		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_grabScreenPos = ASE_ComputeGrabScreenPos( ase_screenPos );
			float4 ase_grabScreenPosNorm = ase_grabScreenPos / ase_grabScreenPos.w;
			float pixelWidth19 =  1.0f / (float)_Pixelation;
			float pixelHeight19 = 1.0f / (float)_Pixelation;
			half2 pixelateduv19 = half2((int)((ase_grabScreenPosNorm).xy.x / pixelWidth19) * pixelWidth19, (int)((ase_grabScreenPosNorm).xy.y / pixelHeight19) * pixelHeight19);
			float4 screenColor13 = UNITY_SAMPLE_SCREENSPACE_TEXTURE(_GrabTexture,pixelateduv19);
			o.Emission = screenColor13.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18921
-1841;566;1238;733;963.6635;151.2877;1.3;True;True
Node;AmplifyShaderEditor.GrabScreenPosition;14;-717.3022,225.5587;Inherit;False;0;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;22;-492.3195,214.4741;Inherit;False;True;True;False;False;1;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.IntNode;33;-472.2534,334.8453;Inherit;False;Property;_Pixelation;Pixelation;0;0;Create;True;0;0;0;False;0;False;50;0;False;0;1;INT;0
Node;AmplifyShaderEditor.TFHCPixelate;19;-289.3032,304.9584;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;500;False;2;FLOAT;500;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScreenColorNode;13;-109.803,256.6584;Inherit;False;Global;_GrabScreen0;Grab Screen 0;1;0;Create;True;0;0;0;False;0;False;Object;-1;False;False;False;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;89.69998,214.5;Float;False;True;-1;7;ASEMaterialInspector;0;0;Unlit;Nanolight/Censor;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;False;-100;False;Overlay;;Overlay;ForwardOnly;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;0;1;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;True;Relative;0;;1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;22;0;14;0
WireConnection;19;0;22;0
WireConnection;19;1;33;0
WireConnection;19;2;33;0
WireConnection;13;0;19;0
WireConnection;0;2;13;0
ASEEND*/
//CHKSM=0D871117C0C2262CC71A160F49DFBC29AD04BA84