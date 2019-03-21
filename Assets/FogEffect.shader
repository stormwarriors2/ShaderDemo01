Shader "Default/FogEffect"
{
	Properties
	{
	   _MainTex("Texture", 2D) = "white" {} // screen
		_Noise("Noise", 2D) = "black" {} // position
		_WarpAmount("Warp Amount", Float) = 15.0 //Warp amount of obj
	}
		SubShader
		{
			// No culling or depth
			Cull Off ZWrite Off ZTest Always

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
				};

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = v.uv;
					return o;
				}

				sampler2D _MainTex;
				sampler2D _Noise;
				float _WarpAmount;

				fixed4 frag(v2f i) : SV_Target
				{
					//w = quadrple time


					fixed4 noise1 = tex2D(_Noise, i.uv + float2(_Time.y * .6, _Time.y));
					fixed4 noise2 = tex2D(_Noise, i.uv + float2(_Time.y * -.1, -_Time.y * .05f));
					fixed2 uv = i.uv + float2(noise1.r , noise2.g) / _WarpAmount; // Calculatat
					fixed4 col = tex2D(_MainTex, uv);

					return col;
				}
				ENDCG
	}
		}
}