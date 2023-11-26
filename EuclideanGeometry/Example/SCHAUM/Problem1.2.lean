import EuclideanGeometry.Foundation.Index
import EuclideanGeometry.Foundation.Axiom.Position.Angle_ex_trash

noncomputable section

namespace EuclidGeom

variable {Plane : Type _} [EuclideanPlane Plane]

namespace Problem1_2_
/-Let $\triangle ABC$ be an isosceles triangle in which $AB = AC$.Let $D$ be a point on $AB$.
Let $E$ be a point on $AC$ such that $AE = AD$.Let $P$ be the foot of perpendicular from $D$ to $BC$.
Let $Q$ be the foot of perpendicular from $E$ to $BC$.

Prove that $DP = EQ$.
-/

--Let $\triangle ABC$ be an isosceles triangle in which $AB = AC$.
variable {A B C : Plane} {hnd: ¬ colinear A B C} {hisoc: (TRI_nd A B C hnd).1.IsIsoceles}
--Let $D$ be a point on $AB$.
variable {D : Plane} {D_on_seg: D LiesInt (SEG A B)}
--Let $E$ be a point on $AC$
variable {E : Plane} {E_on_seg: E LiesInt (SEG A C)}
--such that $AE = AD$.
variable {E_ray_position : (SEG A E).length = (SEG A D).length}
-- Claim:$B \ne C$.
-- This is because vertices  B C of nondegenerate triangles are distinct.
lemma b_ne_c : B ≠ C := (ne_of_not_colinear hnd).1.symm
-- Let $P$ be the foot of perpendicular from $D$ to $BC$.
variable {P : Plane} {hp : P = perp_foot D (LIN B C b_ne_c.symm)}
-- Let $Q$ be the foot of perpendicular from $E$ to $BC$.
variable {Q : Plane} {hq : Q = perp_foot E (LIN B C b_ne_c.symm)}
-- Prove that $DP = EQ$.
theorem Problem1_2_ : (SEG D P).length = (SEG E Q).length := by
  have hisoc' : (SEG A B).length = (SEG A C).length := by
    calc
      _ = (SEG C A).length := hisoc.symm
      _ = (SEG A C).length := length_of_rev_eq_length'
  have seg1 : (SEG B D).length = (SEG C E).length := by
    calc
      _ = (SEG D B).length := length_of_rev_eq_length'
      _ = (SEG A B).length - (SEG A D).length := by
        rw [← eq_sub_of_add_eq']
        symm
        exact length_eq_length_add_length (A := D) D_on_seg
      _ = (SEG A C).length - (SEG A E).length := by rw [E_ray_position, ← hisoc']
      _ = (SEG E C).length := by
        rw [← eq_sub_of_add_eq']
        symm
        exact length_eq_length_add_length (A := E) E_on_seg
      _ = (SEG C E).length := length_of_rev_eq_length'
  have a_ne_b : A ≠ B := (ne_of_not_colinear hnd).2.2.symm
  have a_ne_c : A ≠ C := (ne_of_not_colinear hnd).2.1
  have c_ne_b : C ≠ B := (ne_of_not_colinear hnd).1
  have hnd1 : ¬ colinear P B D := by sorry
  have b_ne_d : B ≠ D := (ne_of_not_colinear hnd1).1.symm
  have p_ne_d : P ≠ D := (ne_of_not_colinear hnd1).2.1
  have p_ne_b : P ≠ B := (ne_of_not_colinear hnd1).2.2.symm
  have hnd2 : ¬ colinear Q C E := by sorry
  have c_ne_e : C ≠ E := (ne_of_not_colinear hnd2).1.symm
  have q_ne_e : Q ≠ E := (ne_of_not_colinear hnd2).2.1
  have q_ne_c : Q ≠ C := (ne_of_not_colinear hnd2).2.2.symm
  have ang2 : (∠ D B P b_ne_d.symm p_ne_b) = - (∠ E C Q c_ne_e.symm q_ne_c) := by
    calc
      _ = ∠ A B C a_ne_b c_ne_b := by
      -- $∠DBP$ and $∠ABC$ are the same angle.
        have : ANG D B P b_ne_d.symm p_ne_b = ANG A B C a_ne_b c_ne_b := by
          apply eq_ang_of_liesint_liesint
          · apply (pt_lies_int_ray_of_pt_pt_iff_pt_lies_int_ray_of_pt_pt b_ne_d.symm a_ne_b).mp
            apply Seg_nd.lies_int_toray_of_lies_int (seg_nd := SEG_nd B A a_ne_b) (Seg_nd.lies_int_rev_iff_lies_int.mp D_on_seg)
          · apply (pt_lies_int_ray_of_pt_pt_iff_pt_lies_int_ray_of_pt_pt c_ne_b p_ne_b).mpr
            rw [hp]
            apply perp_foot_lies_int_ray_of_acute_ang (C := D) (A := B) (B := C) c_ne_b b_ne_d.symm _
            sorry
            sorry
            sorry
        unfold value_of_angle_of_three_point_nd
        congr
      _ = - ∠ A C B a_ne_c c_ne_b.symm := by
      -- The angles are equal by isoceles.
        have : ∠ C B A c_ne_b a_ne_b = ∠ A C B a_ne_c c_ne_b.symm := by
          apply (is_isoceles_tri_iff_ang_eq_ang_of_nd_tri (tri_nd := TRI_nd A B C hnd)).mp hisoc
        rw [neg_value_of_rev_ang a_ne_b c_ne_b, this]
      _ = - ∠ E C Q c_ne_e.symm q_ne_c := by
      -- $∠ACB$ and $∠ECQ$ are the same angle.
        have temp : ANG A C B a_ne_c c_ne_b.symm = ANG E C Q c_ne_e.symm q_ne_c := by
          apply eq_ang_of_liesint_liesint
          · exact Seg_nd.lies_int_toray_of_lies_int (seg_nd := SEG_nd C A a_ne_c) (Seg_nd.lies_int_rev_iff_lies_int.mp E_on_seg)
          · sorry
        unfold value_of_angle_of_three_point_nd
        congr
  have ang1 : (∠ B P D p_ne_b.symm p_ne_d.symm) = - (∠ C Q E q_ne_c.symm q_ne_e.symm) := by sorry
  have h : Triangle_nd.IsACongr (TRI_nd P B D hnd1) (TRI_nd Q C E hnd2) := by
    apply Triangle_nd.acongr_of_AAS
    · exact ang1
    · exact ang2
    · exact seg1
  exact h.edge₂

end Problem1_2_
