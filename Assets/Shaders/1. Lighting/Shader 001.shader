//simple shader that maps the UV coordinates to the Red and Green channel

Shader "Unlit/Shader 001"
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
            };

            struct VertexOutput
            {
                float4 vertex : SV_POSITION;
                float2 uv0 : TEXCOORD0;
            };

            VertexOutput vert (VertexInput v)
            {
                VertexOutput o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv0 = v.uv0;
                return o;
            }

            fixed4 frag (VertexOutput o) : SV_Target
            {
                float2 uv = o.uv0;
                return float4(uv, 0, 0);
            }

            ENDCG
        }
    }
}
