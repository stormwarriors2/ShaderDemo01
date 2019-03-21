Shader "Unlit/vertfrag"
{
    Properties
    {
        _MainTex1 ("Texture1", 2D) = "white" {}
			_MainTex2 ("Texture2", 2D) = "white" {}
					_MBlendTex("BlendTexture", 2D) = "white" {}
					_Threshold("Blend Threshold", float) =  0.5 
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
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float4 norm :  NORMAL;
            };

            struct v2f
            {
                float2 uv1 : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
				float2 uv3 : TEXCOORD2;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex1;
			float4 _MainTex1_ST;

			sampler2D _MainTex2;
			float4 _MainTex2_ST;

			sampler2D _BlendTex;
			float4 _BlendTex_ST;


			float _Threshold;

            v2f vert (appdata v)
            {
                v2f o;

				v.vertex.xyz += sin(_Time.y) * v.norm * .1;

                o.vertex = UnityObjectToClipPos(v.vertex);
			
				o.uv1 = TRANSFORM_TEX(v.uv, _MainTex1);
				o.uv2 = TRANSFORM_TEX(v.uv, _MainTex2);
				o.uv3 = TRANSFORM_TEX(v.uv, _BlendTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col1 = tex2D(_MainTex1, i.uv1);
			fixed4 col2 = tex2D(_MainTex2, i.uv2);
			fixed4 col3 = tex2D(_BlendTex, i.uv3);


			// apply fog


                UNITY_APPLY_FOG(i.fogCoord, col);

				float thresh = (sin(_Time.y)/3.3 + .5);

                return col3.r > thresh ? col1 : col2;
			//	return lerp(col1, col2, col3.r * col3.r);
            }
            ENDCG
        }
    }
}
