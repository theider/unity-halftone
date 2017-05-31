Shader "Hidden/CGAHalftone" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}	
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
 
			#include "UnityCG.cginc"
 
			uniform sampler2D _MainTex;

			float _ObjectColor;

			float4 frag(v2f_img i) : COLOR {
				float4 c = tex2D(_MainTex, i.uv);
				float lum = c.r*.3 + c.g*.59 + c.b*.11;
				float4 output_color = float4(0.3,1,1,1);
				if(lum < 0.4) {
					output_color = float4(1,0.3,1,1);
				}
				float x = i.pos.x;
				float y = i.pos.y;
				float block_size = 8;
				float rad = block_size / 2;
				// depending on lum [0,1] we draw as halftone with black background.
				float cx = (x - (x % block_size)) + rad;
				float cy = (y - (y % block_size)) + rad;
				float dx = x - cx;
				float dy = y - cy;
				float r = sqrt((dx*dx) + (dy*dy));
				float cr = (block_size * lum) / 2;
				if(r > cr) {					
					output_color = float4(0,0,0,1) ; // black
				}
				return output_color;
			}
			ENDCG
		}
	}
}