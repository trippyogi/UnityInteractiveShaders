using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LinesController : MonoBehaviour
{
    private float _audioLevelReceiver;
    private float _offset;
    private Renderer _renderer;
    
    public float AudioLevelReceiver
    {
        get => _audioLevelReceiver;
        set => _audioLevelReceiver = value;
    }

    // Start is called before the first frame update
    void Start()
    {
        _offset = 0;
        _renderer = GetComponent<Renderer>();
        //_renderer.material.shader = Shader.Find("Lines");
    }

    // Update is called once per frame
    void Update()
    {
        _offset += _audioLevelReceiver;
        _renderer.material.SetFloat("_Offset", _offset);
    }
}