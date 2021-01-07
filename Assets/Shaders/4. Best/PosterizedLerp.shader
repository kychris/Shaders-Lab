// Shader with stepping blending

Shader "custom/PosterizedLerp"
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

            float InvLerp (float3 a, float3 b, float3 val)
            {
                return (val - a)/(b - a);
            }

            //a function to banded steps rather than continuous range
            float Posterize(float steps, float val) 
            {
                return floor(val * steps) / steps;
            }

            fixed4 frag (VertexOutput o) : SV_Target
            {
                //get UV property
                float2 uv = o.uv0;

                //two colors to blend
                float3 colorA = float3(0.1, 0.8, 1);
                float3 colorB = float3(1, 0.1, 0.8);

                //use uv.y as the t in lerp
                float t = uv.y;
                //posterize t before use
                t = Posterize(10, t); 
                //blend using t
                float3 blend = lerp(colorA, colorB, t);   

                return float4(blend, 0);
            }
            ENDCG
        }
    }
}
