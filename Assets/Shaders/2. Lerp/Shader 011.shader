// Shader with lerp for color blending

Shader "Unlit/Shader 011"
{
    Properties {
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
                float2 uv = o.uv0;
                float3 normal = normalize(o.normal);

                float3 colorA = float3(0.1, 0.8, 1);
                float3 colorB = float3(1, 0.1, 0.8);
                float3 blend = lerp (colorA, colorB, uv.y);

                return float4(blend, 0);
            }
            ENDCG
        }
    }
}
