// Configurações de resolução
$fn=100;
$fs=0.1;

// Parâmetros (em mm)
hub_d = 12;      // Diâmetro do centro
overall_d = 49;  // Diâmetro total (ponta a ponta)
arm_w = 8;       // Largura da hélice
arm_t = 7;       // Espessura da hélice
overall_t = 9;   // <--- REDUZIDO de 11 para 9 para diminuir a altura do centro
tip_l = 4;       // Comprimento da ponta em V
hole_d = 8;      // Diâmetro do furo inferior
hole_depth = 6;  // Profundidade do furo inferior (cego)

// Comprimento da parte reta (saindo do centro absoluto até o início da ponta)
arm_total_l = (overall_d / 2) - tip_l;

module um_braco() {
  union() {
    // Parte reta do braço começando no centro exato (X=0, Z=0)
    translate([0, -arm_w / 2, 0]) 
      cube([arm_total_l, arm_w, arm_t]);
      
    // Ponta em V
    translate([arm_total_l, 0, 0]) 
      linear_extrude(height = arm_t)
        polygon(points = [[0, -arm_w / 2], [tip_l, 0], [0, arm_w / 2]]);
  }
}

module peca_final() {
  difference() {
    union() {
      // 1. Cilindro central (começa em Z=0 e sobe até a espessura total)
      cylinder(d = hub_d, h = overall_t);
      
      // 2. Adiciona as 5 hélices (começam em Z=0 e se fundem no centro)
      for (i = [0:4]) {
        rotate([0, 0, i * 72]) um_braco();
      }
    }
    
    // Subtração: Furo inferior cego
    // Começa um pouco abaixo de zero (-0.1) para garantir um corte perfeito na base
    translate([0, 0, -0.1]) 
      cylinder(d = hole_d, h = hole_depth + 0.1);
  }
}

// Renderiza a peça final
peca_final();