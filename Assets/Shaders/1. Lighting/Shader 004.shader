// Improving Shader 003 by covering all sides with colors

Shader "Unlit/Shader 004"
{
    Properties {}
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
            };

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
                float3 normal = o.normal * 0.5 + 0.5f; //ensure all sides have a color value by remapping the normal
                return float4(normal, 0);
            }
            ENDCG
        }
    }
}
