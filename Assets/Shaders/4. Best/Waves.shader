// Waves Shader

Shader "Custom/Waves"
{
    Properties {
       _Color ("Color", Color ) = (1,1,1,1)
       _WaterShallow ("_WaterShallow", Color ) = (1,1,1,1)
       _WaterDeep ("_WaterDeep", Color ) = (1,1,1,1)
       _WaveColor ("_WaveColor", Color ) = (1,1,1,1)
       _Gloss ("Gloss", float) = 1
       _ShorelineTex ("Shoreline", 2D) = "black" {}
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
                float3 worldPos : TEXCOORD2;
            };

            float4 _Color;
            float3 _WaterShallow;
            float3 _WaterDeep;
            float3 _WaveColor;

            float _Gloss;
            uniform float3 _MousePos;
            sampler2D _ShorelineTex;

            float Posterize(float steps, float val) 
            {
                return floor(val * steps) / steps;
            }

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv0 = v.uv0;
                o.normal = v.normal;
                o.worldPos = mul(unity_ObjectToWorld, v.vertex); //matrix multiply to get world pos of vertex
                return o;
            }

            fixed4 frag (VertexOutput o) : SV_Target
            {
                float shoreline = tex2D(_ShorelineTex, o.uv0).x;

                float waveSize = 0.04;
                float waveAmp = (sin(shoreline / waveSize + _Time.y*3) + 1) * 0.5; 
                waveAmp *= shoreline; //get depth from map

                float3 waterColor = lerp(_WaterDeep, _WaterShallow, shoreline); 
                float3 waterWithWaves = lerp(waterColor, _WaveColor, waveAmp);

                return float4(waterWithWaves, 0);
            }
            ENDCG
        }
    }
}
