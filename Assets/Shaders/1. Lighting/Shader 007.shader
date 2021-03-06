﻿// Lambert shadings that react to the environment lighting + customizable color controls

Shader "Unlit/Shader 007"
{
    Properties {
       _Color ("Color", Color ) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag 

            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"

            struct VertexInput
            {
                float4 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL; //internally it is TEXCOORD1
            };

            float4 _Color;

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv0 = v.uv0;
                o.normal = v.normal;
                return o;
            }

            fixed4 frag (VertexOutput o) : SV_Target
            {
                float2 uv = o.uv0;

                //lighting
                float3 diffuseLightDir = _WorldSpaceLightPos0; 
                float3 diffuseLightColor = _LightColor0;
                float3 diffuseFallout = max(0, dot(diffuseLightDir, o.normal)); //cos(theta) of the angle between light and normal 
                float3 diffuseLight = diffuseLightColor * diffuseFallout;  //apply color to diffuse light
                float3 ambientLight = float3(0.2, 0.1, 0.0);
                float3 compositeLight = diffuseLight + ambientLight;

                //material
                compositeLight = compositeLight * _Color.rgb; //apply material color

                return float4(compositeLight, 0);
            }
            ENDCG
        }
    }
}
