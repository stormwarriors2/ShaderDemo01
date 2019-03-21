using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnImageEffect : MonoBehaviour
{
    public Material material;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    private void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
   //     material.SetFloat("_WarpAmount", Mathf.Sin(Time.time);
        Graphics.Blit(src, dst, material);
    }
}
